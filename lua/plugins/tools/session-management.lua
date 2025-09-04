return {
	"rmagatti/auto-session",
	lazy = false,
	init = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
	end,
	opts = {
		auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		lazy_support = true,
		continue_restore_on_error = true,
		pre_save_cmds = { "tabdo Neotree close" },
		post_restore_cmds = {
			function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(buf) then
						local name = vim.api.nvim_buf_get_name(buf)
						if name:match("neo%-tree filesystem") or name:match("neo%-tree git") then
							pcall(vim.api.nvim_buf_delete, buf, { force = true })
						end
					end
				end

				local ok, neo = pcall(require, "neo-tree.command")
				if ok then
					neo.execute({ action = "show", source = "filesystem", position = "left", reveal = true })
					neo.execute({ action = "focus", source = "filesystem" })
				end
			end,
		},
		bypass_session_save_file_types = { "neo-tree", "gitcommit" },
	},
}
