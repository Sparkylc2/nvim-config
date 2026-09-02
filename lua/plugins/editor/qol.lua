return {
	-- makes the cursor move faster if you hold it down for a while
	{
		"xiyaowong/fast-cursor-move.nvim",
	},

	-- dims everything but whats focused (based on the config)
	{
		"koenverburg/peepsight.nvim",
		event = "VeryLazy",
		config = function()
			require("peepsight").setup({
				-- ts/js
				"class_declaration",
				"method_definition",
				"arrow_function",
				"function_declaration",
				"generator_function_declaration",
				-- cpp lua etc
				"function_definition",
				"function_declaration",
				-- rust
				"function_item",
				-- latex
				"generic_environment",
				"math_environment",
				"displayed_equation",
				"inline_formula",
				"text_mode",
				"section",
				"subsection",
				"subsubsection",
				"item",
				"enum_item",
				"generic_command",
				"curly_group",
				"brack_group",
			})

			-- vim.api.nvim_set_hl(0, "PeepsightDim", {
			-- 	fg = "#555555",
			-- })
			--
			vim.keymap.set("n", "<leader>p", function()
				require("peepsight").toggle()
			end, { desc = " Peepsight Toggle" })
		end,
	},

	-- hides the tab-bar, lualine, really anything but the code
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		event = "VeryLazy",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
		},
		opts = {
			window = {
				backdrop = 1,
				width = 120,
				height = 1,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorline = false,
					cursorcolumn = false,
					foldcolumn = "0",
					list = false,
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
					laststatus = 0,
				},
				gitsigns = { enabled = true },
				tmux = { enabled = true },
				kitty = {
					enabled = true,
					font = "+4",
				},
			},
		},
	},

	-- easy way to cd into known directories you use often
	{
		"sparkylc2/quick-cd.nvim",
		opts = {
			back = {
				use_autosession = true,
			},
			primary_dirs = {
				Uni = {
					base_dir = "~/Users/lukascampbell/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Year\\/",
					use_autosession = true,
					subdirs = {
						ae = {
							path = "Aerodynamics\\ 2",
						},
						fd = {
							path = "Flight\\ Dynamics\\ and\\ Control",
						},
						math = {
							path = "Mathematics\\ 2",
						},
						exams = {
							path = "Past\\ Exams",
						},
						cs = {
							path = "Computing\\ and\\ Numerical\\ Methods\\ 2",
						},
						labs = {
							path = "Lab\\ Reports",
						},
						mech = {
							path = "Mechatronics",
						},
						pt = {
							path = "Propulsion\\ and\\ Turbomachinery",
						},
						ep = {
							path = "Engineering\\ Practice\\ 2",
						},
						mat = {
							path = "Materials\\ 2",
						},
						misc = {
							path = "Misc",
						},
						struct = {
							path = "Structures\\ 2",
						},
						h = {
							path = "",
						},
					},
				},
			},

			simple_dirs = {
				Config = {
					path = "~/.config/nvim",
					use_autosession = true,
				},
				Snippets = {
					path = "~/.config/nvim/lua/snippets",
					use_autosession = true,
				},
				Github = {
					path = "~/Documents/GitHub/",
					use_autosession = true,
				},
				Personal = {
					path = "~/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Personal/",
					use_autosession = true,
				},
				UROP = {
					path = "~/Library/CloudStorage/OneDrive-ImperialCollegeLondon/UROP/",
					use_autosession = true,
				},
			},
		},
	},

	-- makes sure comment keybinding is correct for given language, and other qol stuff
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("ts-comments").setup(opts)
		end,
	},
}
