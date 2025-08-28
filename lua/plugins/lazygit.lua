return {
	"kdheepak/lazygit.nvim",
	lazy = true,
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		{ "<leader>gc", "<cmd>LazyGitConfig<cr>", desc = "LazyGitConfig" },
		{ "<leader>gf", "<cmd>LazyGitFilter<cr>", desc = "LazyGitFilter" },
		{ "<leader>gcf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGitFilterCurrentFile" },
		{ "<leader>gC", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGitCurrentFile" },
	},
}
