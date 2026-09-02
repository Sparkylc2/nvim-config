return {
	{
		-- dir = "~/documents/github/smart-nav.nvim/",
		"sparkylc2/smart-nav.nvim",
		config = function()
			require("smart-nav").setup({
				use_snippet_tabstops = true,
			})
			-- actually cmd+semicolon
			vim.keymap.set({ "n", "i" }, "<C-x>", require("smart-nav").next)

			-- actually cmd+shift+semicolon
			vim.keymap.set({ "n", "i" }, "<C-b>", require("smart-nav").prev)
		end,
	},
}
