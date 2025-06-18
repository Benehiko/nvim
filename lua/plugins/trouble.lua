return {
	{
		"folke/trouble.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("trouble").setup({
				auto_preview = true,
				auto_close = false,
				auto_jump = {},
				focus = true,
				win = {
					position = "bottom",
					height = 12,
				},
			})

			vim.keymap.set("n", "<leader>ld", function()
				require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
			end)

			vim.keymap.set("n", "<leader>lD", function()
				require("trouble").toggle({ mode = "diagnostics" })
			end)

			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle()
			end)

			vim.keymap.set("n", "[t", function()
				require("trouble").next({ skip_groups = true, jump = true })
			end)

			vim.keymap.set("n", "]t", function()
				require("trouble").previous({ skip_groups = true, jump = true })
			end)
		end,
	},
}
