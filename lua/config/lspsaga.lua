-- lua/config/lspsaga.lua
require("lspsaga").setup({
	-- You can leave this empty for defaults or customize below
	ui = {
		border = "rounded",
		devicon = true,
		zindex = 200,
	},
	symbol_in_winbar = {
		enable = true,
		separator = "  ",
		show_file = true,
	},
	lightbulb = {
		enable = false,
	},
	definition = {
		width = 1.0,
		height = 1.0,
		keys = {
			edit = "o", -- open file
			vsplit = "v",
			split = "s",
			tabe = "t",
			quit = "q",
		},
	},
})
