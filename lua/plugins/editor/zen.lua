-- zen-mode.nvim, kept rather than snacks.zen: this one drives kitty's font size
-- and tmux's status bar, which snacks.zen does not.
--
-- That external state is exactly why the guard below exists. zen-mode restores
-- the kitty font and tmux status on close -- but only if close actually runs. If
-- nvim exits while zen is active (:qa, closing the last buffer, quitting kitty
-- with the window still open) the restore never fires and kitty is left at
-- font +4 for every future session.

return {
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
		},
		opts = {
			window = {
				backdrop = 1,
				width = 240,
				height = 1,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorline = false,
					cursorcolumn = false,
					foldcolumn = "0",
					list = false,
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
					laststatus = 0,
				},
				gitsigns = { enabled = true },
				tmux = { enabled = true },
				kitty = {
					enabled = true,
					font = "+4",
				},
			},
		},
		config = function(_, opts)
			local zen = require("zen-mode")
			zen.setup(opts)

			local function close_zen()
				pcall(zen.close)
			end

			local group = vim.api.nvim_create_augroup("ZenModeGuard", { clear = true })

			-- every path out of nvim, so the kitty font and tmux status are
			-- always restored
			vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
				group = group,
				callback = close_zen,
			})

			-- and if the last real buffer goes away underneath it
			vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
				group = group,
				callback = function()
					vim.schedule(function()
						for _, b in ipairs(vim.api.nvim_list_bufs()) do
							if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= "" then
								return
							end
						end
						close_zen()
					end)
				end,
			})
		end,
	},
}
