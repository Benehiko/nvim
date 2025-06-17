local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local on_attach = function(_, bufnr)
	local map = function(mode, lhs, rhs)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
	end

	map("n", "gd", vim.lsp.buf.definition)
	map("n", "K", vim.lsp.buf.hover)
	map("n", "gi", vim.lsp.buf.implementation)
	map("n", "<leader>rn", vim.lsp.buf.rename)
	map("n", "<leader>ca", vim.lsp.buf.code_action)

	map("n", "<leader>ld", function()
		vim.diagnostic.open_float({ scope = "line" })
	end)

	map("n", "<leader>lD", function()
		vim.diagnostic.setloclist()
		vim.cmd("lopen")
	end)
end

local lsp_servers = {
	"lua_ls",
	"ts_ls",
	"pyright",
	"rust_analyzer",
	"gopls",
	"zls",
	"clangd",
	"sqls",
}

mason_lspconfig.setup({
	automatic_enable = true,
	ensure_installed = lsp_servers,
})

local server_opts = {
	gopls = {
		settings = {
			gopls = {
				buildFlags = { "-tags=cgo" },
				staticcheck = true,
				analyses = { unusedparams = true },
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" }, -- Stop warnings about "vim" being undefined
				},
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		},
	},
}

for _, server in ipairs(lsp_servers) do
	local opts = {
		capabilities = capabilities,
		on_attach = on_attach,
	}

	if server_opts[server] then
		opts = vim.tbl_deep_extend("force", opts, server_opts[server])
	end

	lspconfig[server].setup(opts)
end
