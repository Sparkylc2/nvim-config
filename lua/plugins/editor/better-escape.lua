return {
	{
		"max397574/better-escape.nvim",

		config = function()
			require("better_escape").setup({
				timeout = 50,
				default_mappings = false,
				mappings = {
					i = {
						e = {
							i = "<Esc>",
						},
						i = {
							e = "<Esc>",
						},
					},
					c = {
						e = {
							i = "<Esc>",
						},
						i = {
							e = "<Esc>",
						},
					},

					t = {
						e = {
							i = "<Esc>",
						},
						i = {
							e = "<Esc>",
						},
					},

					v = {
						e = {
							i = "<Esc>",
						},
						i = {
							e = "<Esc>",
						},
					},

					s = {
						e = {
							i = "<Esc>",
						},
						i = {

							e = "<Esc>",
						},
					},
				},
			})
		end,
	},
}
