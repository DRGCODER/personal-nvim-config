return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "echasnovski/mini.icons" },
		opts = {},
		keys = {
			-- Fzf keymaps
			{
				"<leader>ff",
				function()
					require("fzf-lua").files()
				end,
				desc = "Fzf find files",
			},
			{
				"<leader>fc",
				function()
					require("fzf-lua").files({ cwd = "~/.config/nvim" })
				end,
				desc = "Fzf file in config",
			},
			{
				"<leader>fb",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Fzf buffers",
			},
			{
				"<leader>fq",
				function()
					require("fzf-lua").quickfix()
				end,
				desc = "Fzf quick fix list",
			},
			{
				"<leader>ft",
				function()
					require("fzf-lua").tabs()
				end,
				desc = "Fzf tabs",
			},

			-- fzf search keymaps
			{
				"<leader>/",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Fzf live grep",
			},
			{
				"<leader>sc",
				function()
					require("fzf-lua").colorschemes()
				end,
				desc = "Fzf colorschemes",
			},
			{
				"<leader>sb",
				function()
					require("fzf-lua").lgrep_curbuf()
				end,
				desc = "Fzf live gerp current buffer",
			},

			-- git kepmaps
			{
				"<leader>sgs",
				function()
					require("fzf-lua").git_status()
				end,
				desc = "Fzf search git satatus files",
			},
			{
				"<leader>sgd",
				function()
					require("fzf-lua").git_diff()
				end,
				desc = "Fzf search git diffs",
			},
			{
				"<leader>sgh",
				function()
					require("fzf-lua").git_hunks()
				end,
				desc = "Fzf search git hunks",
			},
			{
				"<leader>sgc",
				function()
					require("fzf-lua").git_commits()
				end,
				desc = "Fzf search git all commits",
			},
			{
				"<leader>sgC",
				function()
					require("fzf-lua").git_bcommits()
				end,
				desc = "Fzf search git current buffer commits",
			},
			{
				"<leader>sgB",
				function()
					require("fzf-lua").git_blame()
				end,
				desc = "Fzf search git Blame",
			},
			{
				"<leader>sgb",
				function()
					require("fzf-lua").git_branches()
				end,
				desc = "Fzf search git branches",
			},
			{
				"<leader>sgt",
				function()
					require("fzf-lua").git_tags()
				end,
				desc = "Fzf search git tags",
			},
			{
				"<leader>sgS",
				function()
					require("fzf-lua").git_stash()
				end,
				desc = "Fzf search git staches",
			},

			-- nvim searchinf keymaps
			{
				"<leader>svh",
				function()
					require("fzf-lua").helptags()
				end,
				desc = "Fzf search nvim help",
			},
			{
				"<leader>svm",
				function()
					require("fzf-lua").manpages()
				end,
				desc = "Fzf search nvim man page",
			},
			{
				"<leader>svc",
				function()
					require("fzf-lua").commands()
				end,
				desc = "Fzf search nvim commands",
			},
			{
				"<leader>svj",
				function()
					require("fzf-lua").jumps()
				end,
				desc = "Fzf search nvim jumps",
			},
			{
				"<leader>svk",
				function()
					require("fzf-lua").keymaps()
				end,
				desc = "Fzf search nvim keymaps",
			},

			-- Fzf builtin fuzzy finders
			{
				"<leader>sB",
				function()
					require("fzf-lua").builtin()
				end,
				desc = "Fzf builtins",
			},
		},
	},
}
