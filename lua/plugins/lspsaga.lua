return {
	"nvimdev/lspsaga.nvim",
	commit = "cf6fc9473bba1d332eda9887855ea29ed9b37701",
	event = "LspAttach", -- load only when LSP attaches to a buffer
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- required for symbol navigation
		"nvim-tree/nvim-web-devicons", -- optional, for prettier icons
	},
	config = function()
		require("config.lspsaga") -- Your custom config goes here
	end,
}
