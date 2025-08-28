return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required
	config = function()
		local diffview = require("diffview")

		diffview.setup({
			-- You can tweak settings here
			enhanced_diff_hl = true, -- Better syntax highlighting in diffs
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true,
				},
			},
			file_panel = {
				win_config = { position = "left", width = 35 },
			},
		})

		-- Keymaps
		local map = vim.keymap.set
		local opts = { noremap = true, silent = true }

		map("n", "<leader>do", "<cmd>DiffviewOpen<cr>", opts) -- Open Diffview
		map("n", "<leader>dc", "<cmd>DiffviewClose<cr>", opts) -- Close Diffview
		map("n", "<leader>dh", "<cmd>DiffviewFileHistory<cr>", opts) -- File history
		map("n", "<leader>dr", "<cmd>DiffviewRefresh<cr>", opts) -- Refresh Diffview
	end,
}
