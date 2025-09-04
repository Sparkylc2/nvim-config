-- return {
-- 	{
-- 		"phaazon/hop.nvim",
-- 		branch = "v2",
-- 		keys = {
-- 			{ "s", "<cmd>HopWord<cr>", desc = "Hop to word", mode = { "n", "v" } },
-- 			{ "S", "<cmd>HopLine<cr>", desc = "Hop to line", mode = { "n", "v" } },
-- 		},
-- 		config = true,
-- 	},
-- }
--
-- return {
-- 	{
-- 		"ggandor/leap.nvim",
-- 		dependencies = {
-- 			"tpope/vim-repeat",
-- 		},
-- 		config = function()
-- 			require("leap").set_default_mappings()
-- 		end,
-- 	},
-- }
--
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
			char = { multi_window = false },
		},
	},
	config = function(_, opts)
		local flash = require("flash")
		flash.setup(opts)

		local curwin = { search = { mode = "search", multi_window = false } }

		vim.keymap.set("n", "s", function()
			flash.jump(curwin)
		end, { desc = "Flash jump (normal)" })

		vim.keymap.set("v", "s", function()
			flash.jump(curwin)
		end, { desc = "Flash jump (select)" })

		vim.keymap.set("i", "<D-s>", function()
			flash.jump(curwin)
		end, { desc = "Flash jump (insert)" })

		vim.keymap.set({ "n", "i" }, "<D-p>", function()
			flash.treesitter({ search = { multi_window = false } })
		end, { desc = "Flash TS jump (current window)" })
	end,
}
