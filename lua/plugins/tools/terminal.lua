return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = {
			{ "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
			{ "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal terminal" },
			{ "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical terminal" },
			{
				"<leader>tcf",
				function()
					local buf_path = vim.api.nvim_buf_get_name(0)
					local dir = vim.fn.fnamemodify(buf_path, ":p:h")
					require("toggleterm.terminal").Terminal
						:new({
							direction = "float",
							dir = dir,
							close_on_exit = true,
						})
						:toggle()
				end,
				desc = "Float terminal (cwd of buffer)",
			},
			{
				"<leader>tch",
				function()
					local buf_path = vim.api.nvim_buf_get_name(0)
					local dir = vim.fn.fnamemodify(buf_path, ":p:h")
					require("toggleterm.terminal").Terminal
						:new({
							direction = "horizontal",
							size = 10,
							dir = dir,
							close_on_exit = true,
						})
						:toggle()
				end,
				desc = "Horizontal terminal (cwd of buffer)",
			},
			{
				"<leader>tcv",
				function()
					local buf_path = vim.api.nvim_buf_get_name(0)
					local dir = vim.fn.fnamemodify(buf_path, ":p:h")
					require("toggleterm.terminal").Terminal
						:new({
							direction = "vertical",
							size = 80,
							dir = dir,
							close_on_exit = true,
						})
						:toggle()
				end,
				desc = "Vertical terminal (cwd of buffer)",
			},
		},
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				insert_mappings = true,
				persist_size = true,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
				},
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<C-e>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "<A-k>", "\x1b[D", opts) -- left
				vim.keymap.set("t", "<A-h>", "\x1b[C", opts) -- right
				vim.keymap.set("t", "<A-l>", "\x1b[A", opts) -- up
				vim.keymap.set("t", "<A-u>", "\x1b[B", opts) -- down
			end

			vim.cmd("autocmd! TermOpen term://* lua _G.set_terminal_keymaps()")

			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_loaded(buf) then
							local chan = vim.bo[buf].channel
							if chan > 0 then
								vim.fn.jobstop(chan)
							end
						end
					end
				end,
			})
		end,
	},
}
