return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		cmd = { "CopilotChat", "CopilotChatToggle", "CopilotChatOpen" },
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" },
		},
		opts = {
			window = {
				layout = "vertical",
				width = 0.33,
				title = "Copilot Chat",
			},
		},

		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot chat panel" },
			{ "<leader>cq", "<cmd>CopilotChat<cr>", desc = "Ask Copilot (prompt will pop up)" },
		},
	},
}
