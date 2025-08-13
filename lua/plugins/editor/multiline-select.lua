return {
	"brenton-leighton/multiple-cursors.nvim",
	version = "*", -- Use the latest tagged version
	opts = {},
	keys = {
		{ "<C-y>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" } },
		{ "<C-l>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" } },
		{ "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i" } },
		{ "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i" } },
		{ "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" } },
		{ "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "v" } },
		{ "<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = { "n", "v" } },
		{ "<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "v" } },
		{ "<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>" },
		{ "<Leader>l", "<Cmd>MultipleCursorsLock<CR>" },
	},
}
