local origami = require("origami")

origami.setup({
	-- You can add custom options here, though defaults are fine for most
})

-- Neovim fold settings (Treesitter folds via Neovim's built-in foldexpr)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
