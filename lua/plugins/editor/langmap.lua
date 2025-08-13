return {
	"Wansmer/langmapper.nvim",
	lazy = false,
	priority = 1,
	config = function()
		require("langmapper").setup({
			hack_keymap = true,
			use_layouts = {},
		})

		local lmap = require("langmapper")

		lmap.map("n", "k", "h")
		lmap.map("n", "h", "l")
		lmap.map("n", "l", "k")
		lmap.map("n", "u", "j")

		for _, mode in ipairs({ "v", "x", "o" }) do
			lmap.map(mode, "k", "h")
			lmap.map(mode, "h", "l")
			lmap.map(mode, "l", "k")
			lmap.map(mode, "u", "j")
		end

		lmap.automapping({ global = true, buffer = true })
	end,
}
