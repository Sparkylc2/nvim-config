return {
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
		end,
	},
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
			mappings = {
				N = false,
				E = false,
				I = false,
				O = false,
			},
		},

		keys = {
			{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot chat panel" },
			{ "<leader>cq", "<cmd>CopilotChat<cr>", desc = "Ask Copilot (prompt will pop up)" },
		},
	},
}
