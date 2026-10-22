return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		commit = "29212d826054bb2948fa9d3a99eca9bf6a050eb2",
		lazy = false, -- main branch: plugin does not support lazy-loading
		build = function()
			-- Rebuild/update installed parsers after plugin updates.
			-- Needs the tree-sitter CLI (installed at ~/tools/tree-sitter);
			-- skip with a notice instead of failing hard when it's missing.
			local cli = vim.fn.exepath("tree-sitter")
			if cli == "" then
				local known = vim.fn.expand("~/tools/tree-sitter/tree-sitter")
				if vim.fn.filereadable(known) == 1 then
					cli = known
				end
			end
			if cli == "" then
				vim.notify(
					"tree-sitter CLI not found; install it (e.g. ~/tools/tree-sitter) and run :TSUpdate",
					vim.log.levels.WARN
				)
				return
			end
			vim.env.PATH = vim.fn.fnamemodify(cli, ":h") .. ":" .. vim.env.PATH
			local job = require("nvim-treesitter").update()
			if job then
				job:wait(60000)
			end
		end,

		config = function()
			-- Core plugin setup (install_dir is optional; default is stdpath("data")/site)
			require("nvim-treesitter").setup()

			-- Install parsers for the languages you actually use.
			-- This is async; it is a no-op if the parser is already installed.
			require("nvim-treesitter").install({
				"go",
				"zig",
				"html",
				"css",
				"sql",
				"templ", -- available in nvim-treesitter main branch
				"bash",
				"lua",
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
		commit = "8decd73460d26ef0a0befb745d022dd1fc2c38b8",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		config = function()
			require("treesitter-context").setup({
				enable = true,
			})
		end,
	},
}
