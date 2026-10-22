local mason_lspconfig = require("mason-lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local on_attach = function(_, bufnr)
	local map = function(mode, lhs, rhs)
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
	end

	map("n", "gI", "<cmd>Lspsaga goto_type_definition<CR>")
	map("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
	map("n", "gD", "<cmd>Lspsaga goto_definition<CR>")
	map("n", "gf", "<cmd>Lspsaga finder<CR>")
	map("n", "<leader>la", "<cmd>Lspsaga code_action<CR>")
	map("n", "gr", "<cmd>Lspsaga rename<CR>")
	map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
	map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
	map("n", "K", "<cmd>Lspsaga hover_doc<CR>")
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

local goenv = require("config.goenv")

local goenv_managed = { gopls = "gopls", sqls = "sqls" }

mason_lspconfig.setup({
	automatic_enable = false,
	ensure_installed = vim.tbl_filter(function(server)
		return not goenv_managed[server]
	end, lsp_servers),
})

local server_opts = {
	gopls = {
		cmd = { goenv.bin("gopls") },
		cmd_env = goenv.env,
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

	vim.lsp.config(server, opts)
	if not goenv_managed[server] then
		vim.lsp.enable(server)
	end
end

goenv.ensure(vim.tbl_keys(goenv.tools), function(bins)
	for server, binary in pairs(goenv_managed) do
		if bins[binary] then
			vim.lsp.config(server, { cmd = { bins[binary] } })
		end
		vim.lsp.enable(server)
	end
end)
