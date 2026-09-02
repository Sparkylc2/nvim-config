return {
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble" },
		opts = {
			keywords = {
				TODO = {
					alt = {
						"Todo",
						"todo",
					},
				},
			},
		},
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next Todo Comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous Todo Comment",
			},
			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
			{
				"<leader>xf",
				"<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
				desc = "Todo/Fix/Fixme (Trouble)",
			},
			{
				"<leader>xT",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "Todo",
			},
		},
	},
}
