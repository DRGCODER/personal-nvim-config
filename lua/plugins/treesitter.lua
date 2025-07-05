return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = 'master',
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local configs = require('nvim-treesitter.configs')
            configs.setup({
                ensure_installed = { "lua", "query", "markdown", "markdown_inline", "tsx", "typescript", "go", "python" },
                auto_install = false,
                highlight = {
                    enable = true,
                },
                indent = { enable = true },
                autotage = { enable = true },
            })
        end
    }
}
