return {
	"nvim-pack/nvim-spectre",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("spectre").setup()
		vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Spectre toggle" })
		vim.keymap.set(
			"n",
			"<leader>sw",
			'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
			{ desc = "Spectre search word" }
		)
		vim.keymap.set(
			"v",
			"<leader>sw",
			'<esc><cmd>lua require("spectre").open_visual()<CR>',
			{ desc = "Spectre search select" }
		)
		vim.keymap.set(
			"n",
			"<leader>sp",
			'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
			{ desc = "Spectre search file" }
		)
	end,
}
