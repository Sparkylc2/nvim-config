return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					cmp = true,
					gitsigns = true,
					treesitter = true,
					notify = true,
					telescope = true,
					mini = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
