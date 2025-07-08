return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                transparent = true,
            })
            vim.cmd("colorscheme kanagawa")
        end,
        build = function()
            vim.cmd("KanagawaCompile")
        end,
    },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd([[colorscheme tokyonight]])
    --     end,
    -- },
}
