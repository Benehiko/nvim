return {
	"mrjones2014/smart-splits.nvim",
	commit = "b9d563ea52c4926a4d91e5e795c68bb8f89f8ba0",
	lazy = true,
	event = "VeryLazy",
	opts = {
		ignore_filetypes = { "nofile", "quickfix", "qf", "prompt" },
		ignore_buftypes = { "nofile" },
	},
	config = function()
		require("smart-splits").setup({})
		vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
		vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
		vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
		vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
	end,
}
