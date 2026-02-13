return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false, -- main branch: plugin does not support lazy-loading
		build = ":TSUpdate",

		config = function()
			-- Core plugin setup (install_dir is optional; shown here per upstream example)
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Install parsers (no-op if already installed). This runs async.
			require("nvim-treesitter").install({
				"javascript",
				"typescript",
				"c",
				"lua",
				"rust",
				"jsdoc",
				"bash",
				"go",
				"zig",
				"templ", -- custom parser defined below
			})

			-- Add/override custom language parser definition on TSUpdate
			vim.api.nvim_create_autocmd("User", {
				pattern = "TSUpdate",
				callback = function()
					require("nvim-treesitter.parsers").templ = {
						tier = 2, -- or 1; 2 is a reasonable "community" tier
						install_info = {
							revision = "HEAD",
							url = "https://github.com/vrischmann/tree-sitter-templ.git",
							branch = "master",
							files = { "src/parser.c", "src/scanner.c" },
							-- optional in the new format:
							-- queries = "queries/neovim",
							-- location = "parser",
							-- generate = true,
						},
					}
				end,
			})

			-- If your filetype is literally "templ", register it:
			vim.treesitter.language.register("templ", "templ")

			-- Enable TS highlighting + folds via Neovim (main branch expects you to enable features yourself)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- Start treesitter highlighting for this buffer
					pcall(vim.treesitter.start, args.buf)

					-- Treesitter folds (provided by Neovim)
					vim.wo[0].foldmethod = "expr"
					vim.wo[0].foldexpr = "v:lua.vim.treesitter.foldexpr()"

					-- Optional: Treesitter indentation (experimental; provided by nvim-treesitter)
					-- Comment this out if you dislike TS-indent behavior.
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		config = function()
			require("treesitter-context").setup({
				enable = true,
			})
		end,
	},
}
