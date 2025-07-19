return {
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		opts = {
			bind = true,
			handler_opts = { border = "rounded" },
			floating_window = true,
			floating_window_above_cur_line = true,
			hint_enable = false,
			zindex = 50,
		},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {},
	},
}
