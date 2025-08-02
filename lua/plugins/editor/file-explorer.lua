return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},

		keys = {
			{ "<leader>e", "<cmd>Neotree toggle left<cr>", desc = "Toggle file explorer" },
		},

		opts = {
			filesystem = {
				filtered_items = { visible = true },
				follow_current_file = { enabled = true },
				use_libmuv_file_watcher = true,
			},
			window = {
				mappings = {
					["j"] = "none",
					["k"] = "none",
					["h"] = "none",
					["l"] = "none",
				},
			},
		},

		config = function(_, opts)
			require("neo-tree").setup(opts)

			vim.keymap.set("n", "<leader>E", function()
				if vim.bo.filetype == "neo-tree" then
					if pcall(vim.cmd, "wincmd p") then
						return
					else
						vim.cmd("wincmd l")
						return
					end
				end

				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
					if ft == "neo-tree" then
						vim.api.nvim_set_current_win(win)
						return
					end
				end

				vim.cmd("Neotree reveal left")
			end, { desc = "Toggle focus on Neo-tree" })
		end,
	},
}
