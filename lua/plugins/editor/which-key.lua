return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
		opts = {
			delay = 100,
			filter = function(mapping)
				local lhs = mapping.lhs
				if not lhs then
					return true
				end
				for i = 1, #lhs do
					if lhs:byte(i) > 126 or lhs:byte(i) < 32 then
						return false
					end
				end
				if (mapping.mode == "o" or mapping.mode == "x") and (mapping.keys == "i" or mapping.keys == "a") then
					return false
				end
				return true
			end,
			plugins = { spelling = true },
		},
	},
}
