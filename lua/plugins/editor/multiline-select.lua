return {
	"brenton-leighton/multiple-cursors.nvim",
	version = "*",
	opts = {},
	keys = {
		{ "<C-l>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" }, desc = "Add cursor up" },
		{ "<C-u>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" }, desc = "Add cursor down" },
		{
			"<Leader>ml",
			"<Cmd>MultipleCursorsAddUp<CR>",
			mode = { "n" },
			desc = "Add cursor up (Ctrl-l normally)",
		},
		{
			"<Leader>mu",
			"<Cmd>MultipleCursorsAddDown<CR>",
			mode = { "n" },
			desc = "Add cursor down (-u normally)",
		},

		{
			"<Leader>ma",
			"<Cmd>MultipleCursorsAddMatches<CR>",
			mode = { "n", "v" },
			desc = "Add all matches under cursor",
		},
		{
			"<Leader>md",
			"<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
			mode = { "n", "v" },
			desc = "Add match under cursor and jump to next",
		},
	},
}
