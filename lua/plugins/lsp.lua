return {
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("config.lsp")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}
