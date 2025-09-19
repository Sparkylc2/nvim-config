return {

	{
		"benomahony/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
	},
	{
		"JezerM/oil-lsp-diagnostics.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>e",
				function()
					local oil = require("oil")

					local function statefile_for_session()
						local cwd = vim.fn.getcwd()
						local branch = (function()
							local gitdir = vim.fs.find(".git", { upward = true, path = cwd, type = "directory" })[1]
							if not gitdir then
								return ""
							end
							local out = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
							local b = (out and out[1]) or ""
							return (b ~= "HEAD" and b ~= "") and b or ""
						end)()
						local key = cwd .. (branch ~= "" and ("|" .. branch) or "")

						local slug = key:gsub("[^%w_.-]", "_")
						local dir = vim.fn.stdpath("state") .. "/oil"
						vim.fn.mkdir(dir, "p")
						return dir .. "/last_dir-" .. slug .. ".json"
					end

					local statefile = statefile_for_session()

					local function load_last_dir()
						local f = io.open(statefile, "r")
						if not f then
							return nil
						end
						local ok, data = pcall(vim.json.decode, f:read("*a"))
						f:close()
						return (ok and data and data.path ~= "" and data.path) or nil
					end

					local cur = vim.api.nvim_buf_get_name(0)
					if cur ~= "" and vim.bo.buftype == "" then
						local dir = vim.fn.fnamemodify(cur, ":p:h")
						local file = vim.fn.fnamemodify(cur, ":t")
						oil.open(dir)
						return
					end

					local target = load_last_dir() or vim.fn.getcwd()
					oil.open(target)
				end,
				desc = "Oil: open current file's dir (highlight file) or last session dir",
			},
		},

		opts = {
			default_file_explorer = false,
			skip_confirm_for_simple_edits = true,
			view_options = { show_hidden = true },
			keymaps = {
				["<leader>e"] = "actions.close",
				["s"] = "actions.select",
				[";"] = "actions.parent",
			},
		},

		config = function(_, opts)
			require("oil").setup(opts)
			vim.opt.autochdir = false

			vim.defer_fn(function()
				_G.LOCKED_CWD = vim.fn.getcwd()

				vim.api.nvim_create_autocmd("DirChanged", {
					group = vim.api.nvim_create_augroup("OilLockCwd", { clear = true }),
					callback = function()
						if _G.LOCKED_CWD and vim.fn.getcwd() ~= _G.LOCKED_CWD then
							vim.schedule(function()
								vim.api.nvim_set_current_dir(_G.LOCKED_CWD)
							end)
						end
					end,
				})

				vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
					group = vim.api.nvim_create_augroup("OilBufferCwd", { clear = true }),
					pattern = "oil://*",
					callback = function()
						if _G.LOCKED_CWD and vim.fn.getcwd() ~= _G.LOCKED_CWD then
							vim.api.nvim_set_current_dir(_G.LOCKED_CWD)
						end
					end,
				})
			end, 100)

			local function statefile_for_session()
				local cwd = vim.fn.getcwd()
				local branch = (function()
					local gitdir = vim.fs.find(".git", { upward = true, path = cwd, type = "directory" })[1]
					if not gitdir then
						return ""
					end
					local out = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
					local b = (out and out[1]) or ""
					return (b ~= "HEAD" and b ~= "") and b or ""
				end)()
				local key = cwd .. (branch ~= "" and ("|" .. branch) or "")
				local slug = key:gsub("[^%w_.-]", "_")
				local dir = vim.fn.stdpath("state") .. "/oil"
				vim.fn.mkdir(dir, "p")
				return dir .. "/last_dir-" .. slug .. ".json"
			end

			local function save_last_dir()
				local ok, oil = pcall(require, "oil")
				if not ok then
					return
				end
				local dir = oil.get_current_dir()
				if not dir or dir == "" then
					return
				end
				local f = io.open(statefile_for_session(), "w")
				if f then
					f:write(vim.json.encode({ path = dir }))
					f:close()
				end
			end

			vim.api.nvim_create_autocmd("BufLeave", {
				callback = function()
					if vim.bo.filetype == "oil" then
						pcall(save_last_dir)
					end
				end,
			})
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					pcall(save_last_dir)
				end,
			})

			vim.api.nvim_create_user_command("OilLockCwd", function(opts)
				if opts.args == "" then
					_G.LOCKED_CWD = vim.fn.getcwd()
					print("Locked cwd to: " .. _G.LOCKED_CWD)
				else
					_G.LOCKED_CWD = vim.fn.expand(opts.args)
					vim.api.nvim_set_current_dir(_G.LOCKED_CWD)
					print("Locked cwd to: " .. _G.LOCKED_CWD)
				end
			end, { nargs = "?", complete = "dir" })

			vim.api.nvim_create_user_command("OilDebug", function()
				print("Locked CWD: " .. (_G.LOCKED_CWD or "not set"))
				print("Current CWD: " .. vim.fn.getcwd())
			end, {})
		end,
	},
}
