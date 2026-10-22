local goenv_tools = { "gofumpt", "goimports", "golangci-lint" }

return {
	{
		"stevearc/conform.nvim",
		commit = "016802de402556da54c36bd7359b441266b01cdd",
		opts = {},
		config = function()
			local goenv = require("config.goenv")
			local formatters = {}
			for _, tool in ipairs(goenv_tools) do
				formatters[tool] = {
					command = function()
						return goenv.bin(tool)
					end,
					env = goenv.env,
				}
			end

			require("conform").setup({
				formatters = formatters,
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofumpt", "goimports", "golangci-lint" },
					python = { "black" },
					rust = { "rustfmt", lsp_format = "fallback" },
					typescript = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					zig = { "zigfmt" },
					sql = { "sqlfluff" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					markdown = { "prettier" },
					json = { "prettier" },
					yaml = { "yamlfmt" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
			})
		end,
	},
	{
		"zapling/mason-conform.nvim",
		commit = "48da2ebd5efbaf8a99566eadc3ece82d523f03c5",
		dependencies = {
			"williamboman/mason.nvim",
			"stevearc/conform.nvim",
		},
		opts = {
			ignore_install = vim.list_extend({ "black", "sqlfluff", "clang-format" }, goenv_tools),
		},
	},
}
