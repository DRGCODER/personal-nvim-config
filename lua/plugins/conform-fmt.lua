return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					rust = { "rustfmt" },
					python = { "isort", "ruff" },
					javascript = { "prettierd" },
					typescript = { "prettierd" },
				},
				format_on_save = {
					timeout_ms = 1000,
					lsp_fallback = true,
				},
				formatters = {},
			})
		end,
	},
}
