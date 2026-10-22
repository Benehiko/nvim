return {
	"numToStr/Comment.nvim",
	commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
	config = function()
		require("Comment").setup()
		vim.keymap.set("n", "<leader>/", function()
			require("Comment.api").toggle.linewise.current()
		end, { desc = "Toggle comment linewise" })

		vim.keymap.set("v", "<leader>/", function()
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			vim.api.nvim_feedkeys(esc, "nx", false)
			require("Comment.api").toggle.linewise(vim.fn.visualmode())
		end, { desc = "Toggle comment linewise (visual)" })
	end,
}
