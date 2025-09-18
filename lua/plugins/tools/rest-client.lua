return {
	{
		"rest-nvim/rest.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },

		enabled = false,
		ft = "http",
		keys = {
			{ "<leader>rr", "<Plug>RestNvim", desc = "Run request under cursor" },
			{ "<leader>rp", "<Plug>RestNvimPreview", desc = "Preview request" },
			{ "<leader>rl", "<Plug>RestNvimLast", desc = "Run last request" },
		},
		config = function()
			require("rest-nvim").setup({
				result_split_horizontal = false,
				result_split_in_place = false,
				skip_ssl_verification = false,
				encode_url = true,
				highlight = {
					enabled = true,
					timeout = 150,
				},
			})
		end,
	},
}
