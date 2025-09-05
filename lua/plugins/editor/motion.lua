return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		search = {
			mode = "search",
			multi_window = false,
		},
		modes = {
			search = { multi_window = false },
			char = { enabled = false },
		},
	},
	config = function(_, opts)
		local flash = require("flash")
		flash.setup(opts)

		local curwin = { search = { mode = "search", multi_window = false } }

		vim.keymap.set({ "n", "v" }, "gs", function()
			flash.jump(curwin)
		end, { desc = "Flash jump" })

		vim.keymap.set("i", "<D-s>", function()
			flash.jump(curwin)
		end, { desc = "Flash jump (insert)" })
	end,
}
