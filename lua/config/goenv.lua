local M = {}

M.root = vim.env.GOENV_ROOT or (vim.env.HOME .. "/.goenv")
M.shims = M.root .. "/shims"
M.env = { PATH = M.shims .. ":" .. vim.env.PATH }
M.cache = vim.fn.stdpath("data") .. "/go-tools"
M.checked_against = "1.27"

M.tools = {
	gopls = {
		module = "golang.org/x/tools/gopls",
		releases = {
			{ "v0.24.0", "1.27.0" },
			{ "v0.23.0", "1.26.0" },
			{ "v0.21.1", "1.25" },
			{ "v0.20.0", "1.24.2" },
			{ "v0.18.1", "1.23.4" },
			{ "v0.17.1", "1.23.1" },
			{ "v0.16.2", "1.19" },
			{ "v0.15.3", "1.18" },
		},
	},
	["golangci-lint"] = {
		module = "github.com/golangci/golangci-lint/v2/cmd/golangci-lint",
		releases = {
			{ "v2.15.0", "1.26.0" },
			{ "v2.11.4", "1.25.0" },
			{ "v2.8.0", "1.24.0" },
			{ "v2.1.6", "1.23.0" },
		},
	},
	gofumpt = {
		module = "mvdan.cc/gofumpt",
		releases = {
			{ "v0.12.0", "1.26.0" },
			{ "v0.9.2", "1.24.0" },
			{ "v0.7.0", "1.22" },
		},
	},
	dlv = {
		module = "github.com/go-delve/delve/cmd/dlv",
		releases = {
			{ "v1.27.2", "1.25.0" },
			{ "v1.26.3", "1.24" },
			{ "v1.25.2", "1.22.0" },
			{ "v1.24.2", "1.21" },
		},
	},
	sqls = {
		module = "github.com/sqls-server/sqls",
		releases = {
			{ "v0.2.48", "1.25.0" },
			{ "v0.2.44", "1.24.0" },
			{ "v0.2.28", "1.21" },
		},
	},
	goimports = {
		module = "golang.org/x/tools/cmd/goimports",
		releases = {
			{ "v0.52.0", "1.26.0" },
			{ "v0.43.0", "1.25.0" },
			{ "v0.36.0", "1.23.0" },
			{ "v0.30.0", "1.22.0" },
			{ "v0.24.0", "1.19" },
		},
	},
}

local function parse_version(v)
	local parts = {}
	for n in (v or ""):gsub("^go", ""):gmatch("%d+") do
		table.insert(parts, tonumber(n))
		if #parts == 3 then
			break
		end
	end
	return parts
end

local function at_least(have, need)
	local a, b = parse_version(have), parse_version(need)
	for i = 1, 3 do
		local x, y = a[i] or 0, b[i] or 0
		if x ~= y then
			return x > y
		end
	end
	return true
end

local function go_cmd()
	local shim = M.shims .. "/go"
	if vim.fn.executable(shim) == 1 then
		return shim
	end
	return vim.fn.exepath("go")
end

local go_env_cache

function M.go_env()
	if go_env_cache then
		return go_env_cache
	end
	local go = go_cmd()
	if go == "" then
		return nil
	end
	local ok, result = pcall(function()
		return vim.system({ go, "env", "GOVERSION" }, { text = true, env = M.env }):wait()
	end)
	if not ok or result.code ~= 0 then
		return nil
	end
	go_env_cache = { go = go, version = vim.trim(result.stdout) }
	return go_env_cache
end

function M.candidates(name)
	local env = M.go_env()
	local tool = M.tools[name]
	if not env or not tool then
		return {}
	end
	local list = {}
	for _, release in ipairs(tool.releases) do
		if at_least(env.version, release[2]) then
			table.insert(list, release[1])
		end
	end
	return list
end

local function install_dir(name, version)
	return string.format("%s/%s/%s@%s", M.cache, M.go_env().version, name, version)
end

local function installed(name, version)
	local path = install_dir(name, version) .. "/" .. name
	if vim.fn.executable(path) == 1 then
		return path
	end
end

function M.bin(name)
	for _, version in ipairs(M.candidates(name)) do
		local path = installed(name, version)
		if path then
			return path
		end
	end
	local candidates = M.candidates(name)
	if candidates[1] then
		return install_dir(name, candidates[1]) .. "/" .. name
	end
	local shim = M.shims .. "/" .. name
	if vim.fn.executable(shim) == 1 then
		return shim
	end
	return name
end

local function install(name, versions, i, on_done)
	local env = M.go_env()
	local version = versions[i]
	if not version then
		vim.notify(
			string.format("%s: no release of %s could be built", env.version, name),
			vim.log.levels.ERROR
		)
		on_done(nil)
		return
	end

	local dir = install_dir(name, version)
	vim.fn.mkdir(dir, "p")
	local spec = M.tools[name].module .. "@" .. version
	vim.notify(string.format("%s: installing %s", env.version, spec), vim.log.levels.INFO)

	vim.system({ env.go, "install", spec }, {
		text = true,
		env = vim.tbl_extend("force", M.env, { GOBIN = dir, GOTOOLCHAIN = "local", GOFLAGS = "" }),
	}, function(result)
		vim.schedule(function()
			if result.code == 0 and installed(name, version) then
				vim.notify(string.format("%s: installed %s", env.version, spec), vim.log.levels.INFO)
				on_done(installed(name, version))
				return
			end
			vim.fn.delete(dir, "rf")
			vim.notify(
				string.format("%s: %s failed to build, trying an older release\n%s", env.version, spec, result.stderr or ""),
				vim.log.levels.WARN
			)
			install(name, versions, i + 1, on_done)
		end)
	end)
end

function M.warn_if_outdated()
	local env = M.go_env()
	if not env then
		return
	end
	local have, checked = parse_version(env.version), parse_version(M.checked_against)
	local newer = (have[1] or 0) > (checked[1] or 0)
		or ((have[1] or 0) == (checked[1] or 0) and (have[2] or 0) > (checked[2] or 0))
	if not newer then
		return
	end

	local marker = string.format("%s/%s/.outdated-warned", M.cache, env.version)
	if vim.fn.filereadable(marker) == 1 then
		return
	end
	vim.fn.mkdir(vim.fn.fnamemodify(marker, ":h"), "p")
	vim.fn.writefile({}, marker)

	vim.schedule(function()
		vim.notify(
			string.format(
				"%s is newer than Go %s, the last version the Go tool releases in lua/config/goenv.lua were checked against. "
					.. "Newer gopls/golangci-lint releases may exist; add them to the release tables and bump checked_against.",
				env.version,
				M.checked_against
			),
			vim.log.levels.WARN
		)
	end)
end

function M.ensure(names, on_done)
	M.warn_if_outdated()
	local results = {}
	local pending = 0
	local missing = {}

	for _, name in ipairs(names) do
		local versions = M.candidates(name)
		local path = versions[1] and installed(name, versions[1])
		if path or not versions[1] then
			results[name] = M.bin(name)
		else
			table.insert(missing, { name = name, versions = versions })
		end
	end

	if #missing == 0 then
		vim.schedule(function()
			on_done(results)
		end)
		return
	end

	pending = #missing
	for _, item in ipairs(missing) do
		install(item.name, item.versions, 1, function(path)
			results[item.name] = path or M.bin(item.name)
			pending = pending - 1
			if pending == 0 then
				on_done(results)
			end
		end)
	end
end

return M
