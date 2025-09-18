return {
	"rmagatti/auto-session",
	lazy = false,
	init = function()
		-- Keep curdir OUT of sessionoptions
		vim.o.sessionoptions = "blank,buffers,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
	opts = {
		auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		lazy_support = true,
		continue_restore_on_error = true,
		cwd_change_handling = {
			restore_upcoming_session = false,
		},
		pre_save_cmds = {
			function()
				-- Save Neo-tree's current position before closing
				local manager = require("neo-tree.sources.manager")
				local state = manager.get_state("filesystem")
				if state and state.path then
					vim.g.neotree_last_position = state.path
				end
				vim.cmd("tabdo Neotree close")
			end,
		},
		post_restore_cmds = {
			function()
				-- Clean up neo-tree buffers
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) then
						local name = vim.api.nvim_buf_get_name(buf)
						if name:match("neo%-tree filesystem") or name:match("neo%-tree git") then
							pcall(vim.api.nvim_buf_delete, buf, { force = true })
						end
					end
				end

				-- Restore Neo-tree to its saved position if it exists
				vim.defer_fn(function()
					if vim.g.neotree_last_position then
						local path = vim.g.neotree_last_position
						vim.g.neotree_last_position = nil
						-- Open Neo-tree at the saved position
						require("neo-tree.command").execute({
							action = "show",
							source = "filesystem",
							dir = path,
						})
					end
				end, 100)
			end,
		},
		bypass_session_save_file_types = { "neo-tree", "gitcommit" },
	},
}
