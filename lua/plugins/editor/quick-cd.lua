return {
	{
		"sparkylc2/quick-cd.nvim",
		opts = {

			back = {
				use_autosession = true,
			},
			primary_dirs = {
				Uni = {
					base_dir = "~/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Year\\ 2/",
					use_autosession = true,
					subdirs = {
						ae = {
							path = "Aerodynamics\\ 2",
						},
						fd = {
							path = "Flight\\ Dynamics\\ and\\ Control",
						},
						math = {
							path = "Mathematics\\ 2",
						},
						exams = {
							path = "Past\\ Exams",
						},
						cs = {
							path = "Computing\\ and\\ Numerical\\ Methods\\ 2",
							post = function(target)
								local function disable_copilot_when_ready(opts)
									opts = opts or {}
									local tries, max_try, delay = 0, opts.max_try or 40, opts.delay or 100
									vim.g.copilot_enabled = false
									vim.g.copilot_filetypes = vim.g.copilot_filetypes or {}
									vim.g.copilot_filetypes["*"] = false

									local function kill_lsp()
										for _, client in ipairs(vim.lsp.get_active_clients()) do
											if client.name == "copilot" then
												pcall(function()
													client.stop(true)
												end)
											end
										end
									end

									local function tick()
										tries = tries + 1
										local has_cmd = vim.fn.exists(":Copilot") == 2
										local ok_mod, copilot = pcall(require, "copilot")
										local ok_cmd_mod, cop_cmd = pcall(require, "copilot.command")

										if has_cmd then
											vim.cmd("silent! Copilot disable")
											kill_lsp()
											return
										end

										if ok_cmd_mod and type(cop_cmd.Disable) == "function" then
											pcall(cop_cmd.Disable)
											kill_lsp()
											return
										end

										if ok_mod and type(copilot.disable) == "function" then
											pcall(copilot.disable)
											kill_lsp()
											return
										end

										if tries < max_try then
											vim.defer_fn(tick, delay)
										else
											kill_lsp()
										end
									end

									tick()
								end

								if target:find("Computing and Numerical Methods 2", 1, true) then
									disable_copilot_when_ready({ max_try = 60, delay = 100 })
								end
							end,
						},
						labs = {
							path = "Lab\\ Reports",
							pre = function(target)
								for _, buf in ipairs(vim.api.nvim_list_bufs()) do
									if vim.api.nvim_buf_is_valid(buf) then
										local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
										if buftype == "terminal" then
											vim.api.nvim_buf_delete(buf, { force = true })
										end
									end
								end
							end,
						},
						mech = {
							path = "Mechatronics",
						},
						pt = {
							path = "Propulsion\\ and\\ Turbomachinery",
						},
						ep = {
							path = "Engineering\\ Practice\\ 2",
						},
						mat = {
							path = "Materials\\ 2",
						},
						misc = {
							path = "Misc",
						},
						struc = {
							path = "Structures\\ 2",
						},
						h = {
							path = "",
						},
					},
				},
			},

			simple_dirs = {
				Config = {
					path = "~/.config/nvim",
					use_autosession = true,
				},
				Github = {
					path = "~/Documents/GitHub/",
					use_autosession = true,
				},
				Personal = {
					path = "~/Library/CloudStorage/OneDrive-ImperialCollegeLondon/Personal/",
					use_autosession = true,
				},
			},
		},
	},
}
