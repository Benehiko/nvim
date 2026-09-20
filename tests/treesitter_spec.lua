-- Regression tests for the nvim-treesitter setup and the languages in use.
local h = require("harness")

-- Languages the config installs parsers for.
local languages = { "go", "zig", "html", "css", "sql", "templ", "bash", "lua" }

-- Small snippets used to verify that highlighting actually starts.
local samples = {
	go = 'package main\n\nimport "fmt"\n\nfunc main() {\n\tfmt.Println("hello")\n}\n',
	zig = 'const std = @import("std");\n\npub fn main() void {\n    std.debug.print("hi\\n", .{});\n}\n',
	html = "<!DOCTYPE html>\n<html><body><h1>Title</h1></body></html>\n",
	css = "body { color: red; background: #fff; }\n",
	sql = "SELECT * FROM users WHERE id = 1;\n",
	templ = "package main\n\ntempl Hello(name string) {\n  <div>Hello, { name }!</div>\n}\n",
	bash = "#!/bin/bash\necho hello\n",
	lua = "local x = 1\nprint(x)\n",
}

h.describe("treesitter", function()
	h.it("plugin setup succeeds", function()
		local ok, err = pcall(function()
			require("nvim-treesitter").setup()
		end)
		h.truthy(ok, "setup failed: " .. tostring(err))
	end)

	h.it("parsers are installed for every configured language", function()
		local installed = require("nvim-treesitter").get_installed()
		local present = {}
		for _, lang in ipairs(installed) do
			present[lang] = true
		end
		for _, lang in ipairs(languages) do
			h.truthy(present[lang], "parser not installed: " .. lang)
		end
	end)

	h.it("every language parser loads", function()
		for _, lang in ipairs(languages) do
			local ok, err = pcall(vim.treesitter.language.add, lang)
			h.truthy(ok, lang .. " failed to load: " .. tostring(err))
		end
	end)

	h.it("highlighting starts on sample buffers", function()
		for _, lang in ipairs(languages) do
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(samples[lang], "\n"))
			local ok, err = pcall(vim.treesitter.start, buf, lang)
			h.truthy(ok, lang .. " failed to start highlighting: " .. tostring(err))
			h.truthy(
				vim.treesitter.highlighter.active[buf] ~= nil,
				lang .. " has no active highlighter after start"
			)
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end)

	h.it("treesitter foldexpr is available", function()
		local buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "local x = 1", "if x then", "end" })
		vim.treesitter.start(buf, "lua")
		vim.api.nvim_set_current_buf(buf)
		local ok, result = pcall(vim.treesitter.foldexpr, 2)
		h.truthy(ok, "foldexpr failed: " .. tostring(result))
		h.truthy(result ~= nil, "foldexpr returned nil")
		vim.api.nvim_buf_delete(buf, { force = true })
	end)

	h.it("startup produced no error messages", function()
		local messages = vim.api.nvim_exec2("messages", { output = true }).output
		local errors = {}
		for _, line in ipairs(vim.split(messages, "\n")) do
			if line:match("^E%d+") or line:lower():match("abi") or line:lower():match("error") then
				table.insert(errors, line)
			end
		end
		h.eq(errors, {}, "unexpected error messages")
	end)
end)

h.describe("config", function()
	local root = vim.g.nvim_config_root

	h.it("treesitter plugin spec defines an install list and a robust build step", function()
		local spec = dofile(root .. "/lua/plugins/treesitter.lua")
		local plugin = spec[1]
		h.eq(plugin[1], "nvim-treesitter/nvim-treesitter", "unexpected plugin name")
		h.eq(type(plugin.build), "function", "build must be a function that tolerates a missing CLI")
		h.eq(type(plugin.config), "function", "config must be a function")
	end)

	h.it("origami sets a working treesitter fold expression", function()
		local source = table.concat(vim.fn.readfile(root .. "/lua/config/origami.lua"), "\n")
		h.truthy(
			source:find("vim%.treesitter%.foldexpr") ~= nil,
			"origami must use Neovim's native foldexpr"
		)
		h.eq(
			source:find("nvim_treesitter#foldexpr", 1, true),
			nil,
			"origami must not use the removed nvim_treesitter#foldexpr"
		)
	end)
end)