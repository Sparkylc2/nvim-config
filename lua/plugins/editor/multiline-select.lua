return {
	"brenton-leighton/multiple-cursors.nvim",
	version = "*",

	opts = {},
	keys = {
		-- { "<C-u>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" } },
		-- { "<C-l>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" } },
		{ "<D-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" } },
		{ "<D-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" } },

		{ "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
		{ "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "v" } },
		{ "<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = { "n", "v" } },
		{ "<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "v" } },
		{ "<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>" },
	},
}
