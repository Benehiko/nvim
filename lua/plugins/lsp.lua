return {
	{
		"williamboman/mason.nvim",
		commit = "2a6940af80375532e5e9e7c1f2fc6319a1b7a69d",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		commit = "27b98a54bc04d2e8649d2e701c89aec0d02c11a4",
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
		commit = "44acfe887d4056f704ccc4f17513ed41c9e2b2e6",
		lazy = true,
	},
	{
		"j-hui/fidget.nvim",
		commit = "9e0201673e08e997e7cf52afca5565c70bd117f3",
		opts = {},
	},
}
