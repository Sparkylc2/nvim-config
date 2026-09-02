return {
	-- makes the cursor move faster if you hold it down for a while
	{
		"xiyaowong/fast-cursor-move.nvim",
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
