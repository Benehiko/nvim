return {
    {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    go = { "gofumpt", "goimports", "golangci-lint" },
                    python = { "black" },
                    rust = { "rustfmt", lsp_format = "fallback" },
                    typescript = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                    c = { "clang_format" },
                    cpp = { "clang_format" },
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
    -- auto-installer
    {
        "zapling/mason-conform.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "stevearc/conform.nvim",
        },
        config = true,
    },
}
