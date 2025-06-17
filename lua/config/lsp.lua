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
	ensure_installed = lsp_servers,
})

for _, server in ipairs(lsp_servers) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-- Optional: special case for lua_ls
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
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
})
