return {
	"jiaoshijie/undotree",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keymaps = {
			u = "move_next",
			l = "move_prev",
			gl = "move2parent",
			U = "move_change_next",
			L = "move_change_prev",
			["<cr>"] = "action_enter",
			p = "enter_diffbuf",
			q = "quit",
		},
	},
	keys = {
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	},
}
