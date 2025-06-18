return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach", -- load only when LSP attaches to a buffer
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- required for symbol navigation
		"nvim-tree/nvim-web-devicons", -- optional, for prettier icons
	},
	config = function()
		require("config.lspsaga") -- Your custom config goes here
	end,
}
