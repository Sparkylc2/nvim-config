return {
	"obsidian-nvim/obsidian.nvim",
	lazy = true,
	ft = "markdown",
	opts = {
		legacy_commands = false,
		workspaces = {
			{
				name = "Year 3",
				path = "~/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Year 3",
			},
		},

		picker = {
			name = "snacks.picker",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
		},

		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},

		preferred_link_style = "wiki",

		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true, desc = "Follow Obsidian link" },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true, desc = "Toggle Checkbox" },
			},
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true, desc = "Smart Action" },
			},
		},
	},
}
