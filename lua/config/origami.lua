local origami = require("origami")

origami.setup({
	-- You can add custom options here, though defaults are fine for most
})

-- Neovim fold settings (essential for Treesitter-based folding)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
