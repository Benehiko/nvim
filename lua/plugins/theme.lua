return {
	{
		"folke/tokyonight.nvim",
		commit = "5da1b76e64daf4c5d410f06bcb6b9cb640da7dfd",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
