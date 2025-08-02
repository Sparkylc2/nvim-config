return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatOpen" },
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim" }, -- async utils
		},
		opts = {
			window = {
				layout = "vertical", -- vsplit
				width = 0.33, -- 33 % of the editor
				title = "Copilot Chat", -- optional header
			}, -- full list of window options in README
		},

		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot chat panel" },
			{ "<leader>cq", "<cmd>CopilotChat<cr>", desc = "Ask Copilot (prompt will pop up)" },
		},
	},
}
