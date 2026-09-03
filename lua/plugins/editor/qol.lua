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
					base_dir = "~/Users/lukascampbell/OneDrive\\ -\\ Imperial\\ College\\ London/Year\\ 2",
					use_autosession = true,
					subdirs = {
						writing = {
							path = "Advanced\\ Creative\\ Writing",
						},
						ae = {
							path = "Aerodynamics\\ 3",
						},
						vdes = {
							path = "Aerospace\\ Vehicle\\ Design",
						},
						cs = {
							path = "High\\ Performance\\ Computing",
						},
						ctrl = {
							path = "Control\\ Systems",
						},
						desproj = {
							path = "Group\\ Design\\ Project",
						},
						math = {
							path = "Mathematics\\ 3",
						},
						exams = {
							path = "Past\\ Exams",
						},
						labs = {
							path = "Lab\\ Reports",
						},
						misc = {
							path = "Misc",
						},
						struct = {
							path = "Structures\\ 3",
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
