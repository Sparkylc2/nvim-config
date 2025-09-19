return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		keys = {
			{
				"<S-k>",
				function()
					require("smart-splits").move_cursor_left()
				end,
				desc = "Move to left split",
			},
			{
				"<S-u>",
				function()
					require("smart-splits").move_cursor_down()
				end,
				desc = "Move to split below",
			},
			{
				"<S-l>",
				function()
					require("smart-splits").move_cursor_up()
				end,
				desc = "Move to split above",
			},
			{
				"<S-h>",
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
				resize_keys = { "k", "u", "l", "h" },
				silent = false,
			},
		},
	},
}
