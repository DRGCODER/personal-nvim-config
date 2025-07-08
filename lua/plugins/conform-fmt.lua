return {
    {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    python = { "isort", "black", "ruff" },
                    javascript = { "prettierd", "prettier" },
                    typescript = { "prettierd", "prettier" },
                },
                format_on_save = {
                    timeout_ms = 1000,
                    lsp_fallback = true,
                },
                formatters = {
                    javascript = {
                        stop_after_first = true, 
                    },
                },
            })
        end,
    },
}
