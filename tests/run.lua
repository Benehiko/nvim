-- Headless entry point: loads the config, runs every spec, exits non-zero on failure.
local root = vim.env.NVIM_CONFIG_ROOT or vim.fn.stdpath("config")
vim.g.nvim_config_root = root
package.path = root .. "/tests/?.lua;" .. package.path

-- Make sure the plugins under test are loaded before the specs run.
pcall(function()
	require("lazy").load({ plugins = { "nvim-treesitter" } })
end)

local harness = require("harness")
dofile(root .. "/tests/treesitter_spec.lua")

local ok = harness.run()
vim.cmd(ok and "qa!" or "cquit 1")