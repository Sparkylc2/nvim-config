return {
	{
		"sparkylc2/smart-nav.nvim",
		config = function()
			require("smart-nav").setup()
			vim.keymap.set({ "n", "i" }, "<D-;>", require("smart-nav").next)
			vim.keymap.set({ "n", "i" }, "<D-S-;>", require("smart-nav").prev)
		end,
	},
}
