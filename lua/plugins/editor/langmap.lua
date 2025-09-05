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

		for _, mode in ipairs({ "n", "v", "x" }) do
			lmap.map(mode, "k", "h")
			lmap.map(mode, "h", "l")
			lmap.map(mode, "l", "k")
			lmap.map(mode, "u", "j")
		end

		lmap.automapping({ global = true, buffer = true })
	end,
}
