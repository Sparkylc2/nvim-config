return {
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "TodoTelescope" },
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
			{ "<leader>xt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
			{ "<leader>xT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
		},
		opts = {},
		-- config = function(_, opts)
		-- 	opts.keywords = {
		-- 		TODO = { icon = "", color = "info" },
		-- 		FIX = { icon = "", color = "error", alt = { "FIXME", "BUG" } },
		-- 		NOTE = { icon = "", color = "hint", alt = { "INFO" } },
		-- 		IMPORTANT = { icon = "", color = "warning", alt = { "HIGHLIGHT" } },
		-- 	}
		-- 	require("todo-comments").setup(opts)
		-- end,
	},
}
