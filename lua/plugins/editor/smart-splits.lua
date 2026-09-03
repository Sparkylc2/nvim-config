return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		opts = {
			ignored_filetypes = { "nofile", "quickfix", "prompt" },
			ignored_buftypes = { "NvimTree", "neo-tree" },
			default_amount = 3,
			at_edge = "wrap",
			move_cursor_same_row = false,
			cursor_follows_swapped_bufs = false,
			multiplexer_integration = "tmux",
			resize_mode = {
				quit_key = "<ESC>",
				resize_keys = { "n", "e", "i", "o" },
				silent = false,
			},
		},
	},
}
