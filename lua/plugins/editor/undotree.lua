return {
	"jiaoshijie/undotree",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keymaps = {
			e = "move_next",
			i = "move_prev",
			gi = "move2parent",
			E = "move_change_next",
			I = "move_change_prev",
			["<cr>"] = "action_enter",
			p = "enter_diffbuf",
			q = "quit",
		},
	},
	keys = {
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}
