-- Minimal, dependency-free test harness for headless Neovim checks.
local M = {}

local tests = {}
local group = "general"

-- Register a named group of tests. Nested calls restore the previous group.
function M.describe(name, fn)
	local previous = group
	group = name
	fn()
	group = previous
end

-- Register a single test case in the current group.
function M.it(name, fn)
	table.insert(tests, { group = group, name = name, fn = fn })
end

function M.fail(message)
	error(message, 2)
end

function M.truthy(value, message)
	if not value then
		M.fail((message or "expected a truthy value") .. ", got: " .. vim.inspect(value))
	end
end

function M.eq(actual, expected, message)
	if not vim.deep_equal(actual, expected) then
		M.fail(
			(message or "values differ")
				.. "\n  expected: "
				.. vim.inspect(expected)
				.. "\n  actual:   "
				.. vim.inspect(actual)
		)
	end
end

-- Run every registered test and report a summary. Returns true on success.
function M.run()
	local passed, failed = 0, 0
	local failures = {}

	for _, test in ipairs(tests) do
		local ok, err = pcall(test.fn)
		if ok then
			passed = passed + 1
			io.write(string.format("  ok   %s > %s\n", test.group, test.name))
		else
			failed = failed + 1
			table.insert(failures, { test = test, err = err })
			io.write(string.format("  FAIL %s > %s\n", test.group, test.name))
		end
	end

	io.write(string.format("\n%d passed, %d failed\n", passed, failed))
	for _, failure in ipairs(failures) do
		io.write(string.format("\nFAIL %s > %s\n%s\n", failure.test.group, failure.test.name, tostring(failure.err)))
	end
	io.write("\n")

	return failed == 0
end

return M