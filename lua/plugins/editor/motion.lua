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
return {
	{
		"ggandor/leap.nvim",
		dependencies = {
			"tpope/vim-repeat",
		},
		config = function()
			require("leap").set_default_mappings()
		end,
	},
}
