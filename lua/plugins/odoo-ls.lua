return {
    'whenrow/odoo-ls.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
        local odools = require('odools')
        local h = os.getenv('HOME')
        odools.setup({
            -- mandatory
            odoo_path = h .. "/src/odoo/",
            python_path = h .. "/.pyenv/shims/python3",

            -- optional
            server_path = h .. "/.local/share/nvim/odoo/odoo_ls_server",
            addons = { h .. "/src/enterprise/" },
            additional_stubs = { h .. "/src/additional_stubs/", h .. "/src/typeshed/stubs" },
            root_dir = h .. "/src/", -- working directory, odoo_path if empty
            settings = {
                autoRefresh = true,
                autoRefreshDelay = nil,
                diagMissingImportLevel = "none",
            },
        })
    end
}
