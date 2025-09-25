return {
	"kylechui/nvim-surround",
	event = "VeryLazy",
	config = function()
		require("nvim-surround").setup({})
		vim.keymap.set("x", "ys", "<Plug>(nvim-surround-visual)", { noremap = false, silent = true })
	end,
}
