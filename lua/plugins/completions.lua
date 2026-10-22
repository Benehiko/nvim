return {
	{
		"hrsh7th/nvim-cmp",
		commit = "da88697d7f45d16852c6b2769dc52387d1ddc45f",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("config.completions")
		end,
	},
}
