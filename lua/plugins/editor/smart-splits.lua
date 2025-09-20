return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		keys = {
			{
				"<S-n>",
				function()
					require("smart-splits").move_cursor_left()
				end,
				desc = "Move to left split",
			},
			{
				"<S-e>",
				function()
					require("smart-splits").move_cursor_down()
				end,
				desc = "Move to split below",
			},
			{
				"<S-i>",
				function()
					require("smart-splits").move_cursor_up()
				end,
				desc = "Move to split above",
			},
			{
				"<S-o>",
				function()
					require("smart-splits").move_cursor_right()
				end,
				desc = "Move to right split",
			},
			{
				"<C-h>",
				function()
					require("smart-splits").move_cursor_left()
				end,
				desc = "Move to left split",
			},
			{
				"<C-j>",
				function()
					require("smart-splits").move_cursor_down()
				end,
				desc = "Move to split below",
			},
			{
				"<C-k>",
				function()
					require("smart-splits").move_cursor_up()
				end,
				desc = "Move to split above",
			},
			{
				"<C-l>",
				function()
					require("smart-splits").move_cursor_right()
				end,
				desc = "Move to right split",
			},
		},
		opts = {
			ignored_filetypes = { "nofile", "quickfix", "prompt" },
			ignored_buftypes = { "NvimTree", "neo-tree" },
			default_amount = 3,
			at_edge = "wrap",
			move_cursor_same_row = false,
			cursor_follows_swapped_bufs = false,
			multiplexer_integration = "zellij",
			resize_mode = {
				quit_key = "<ESC>",
				resize_keys = { "n", "e", "i", "o" },
				silent = false,
			},
		},
	},
}
