return {
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = 15,
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

					-- In terminal mode <Esc> is just a byte handed to the shell; it does
					-- NOT leave terminal mode (better-escape feeds keys with "n", so
					-- the buffer-local <esc> map never applies). <C-\><C-n> is the
					-- only thing that actually gets you to normal mode.
					t = {
						e = {
							i = [[<C-\><C-n>]],
						},
						i = {
							e = [[<C-\><C-n>]],
						},
					},
				},
			})
		end,
	},
}
