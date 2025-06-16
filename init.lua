vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Close the current buffer
vim.keymap.set("n", "<space>c", function()
	if vim.bo.modified then
		local choice = vim.fn.confirm("Buffer has unsaved changes. Save?", "&Yes\n&No\n&Cancel")
		if choice == 1 then
			vim.cmd("write")
			vim.cmd("bdelete")
		elseif choice == 2 then
			vim.cmd("bdelete!")
		end
	-- Cancel does nothing
	else
		vim.cmd("bdelete")
	end
end, { desc = "Smart close buffer" })

-- auto-install Lazy if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
require("config.set")

-- Remap Yank to store whatever is yanked into the Clipboard
-- Pase whatever is in the clipboard as well
-- Use system clipboard for yank, delete, and paste in normal and visual mode
local opts = { noremap = true, silent = true }

-- Function to highlight yanked text
local function clipboard_yank_highlight()
	vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
end

-- Normal mode
vim.keymap.set("n", "y", '"+y', opts)
vim.keymap.set("n", "yy", function()
	vim.cmd('normal! "+yy"')
	clipboard_yank_highlight()
end, opts)

vim.keymap.set("n", "d", '"+d', opts)
vim.keymap.set("n", "dd", '"+dd', opts)
vim.keymap.set("n", "x", '"+x', opts)
vim.keymap.set("n", "p", '"+p', opts)
vim.keymap.set("n", "P", '"+P', opts)

-- Visual mode
vim.keymap.set("v", "y", function()
	vim.cmd('normal! "+y"')
	clipboard_yank_highlight()
end, opts)
vim.keymap.set("v", "d", '"+d', opts)
vim.keymap.set("v", "x", '"+x', opts)
vim.keymap.set("v", "p", '"+p', opts)
vim.keymap.set("v", "P", '"+P', opts)
