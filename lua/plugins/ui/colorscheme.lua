return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
				overrides = function(c)
					local t = c.theme
					return {
						-- menu window
						BlinkCmpMenu = { bg = t.ui.bg_p1, fg = t.ui.fg },
						BlinkCmpMenuBorder = { bg = t.ui.bg_p1, fg = t.ui.bg_p1 },

						-- docs/signature window
						BlinkCmpDoc = { bg = t.ui.bg_m2, fg = t.ui.fg },
						BlinkCmpDocBorder = { bg = t.ui.bg_m2, fg = t.ui.bg_m2 },
						BlinkCmpSignatureHelp = { bg = t.ui.bg_m2, fg = t.ui.fg },
						BlinkCmpSignatureHelpBorder = { bg = t.ui.bg_m2, fg = t.ui.bg_m2 },
					}
				end,
			})

			vim.cmd("colorscheme kanagawa-dragon")
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					local colors = {
						bg = "#181616",
						bg_light = "#282727",
						fg = "#c5c9c5",
						border = "#54546D",
					}
					vim.api.nvim_set_hl(0, "SignColumn", { bg = "#181616" })
					vim.api.nvim_set_hl(0, "LineNr", { bg = "#181616", fg = "#625E5A" })
					vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "#181616", fg = "#FF5D62" })
					vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = "#181616", fg = "#E6C384" })
					vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = "#181616", fg = "#7FB4CA" })
					vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = "#181616", fg = "#98BB6C" })

					local function set_git_sign_bgs()
						local bg = "#181616"

						vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })

						local groups = {
							"GitSignsAdd",
							"GitSignsChange",
							"GitSignsDelete",
							"GitSignsTopdelete",
							"GitSignsChangedelete",
							"GitSignsUntracked",
						}

						for _, grp in ipairs(groups) do
							local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = grp, link = false })
							if ok and hl then
								local new = {
									bg = bg,
									fg = hl.fg,
									bold = hl.bold or false,
									italic = hl.italic or false,
									underline = hl.underline or false,
									undercurl = hl.undercurl or false,
									strikethrough = hl.strikethrough or false,
									reverse = hl.reverse or false,
									nocombine = hl.nocombine or false,
								}
								vim.api.nvim_set_hl(0, grp, new)
							else
								vim.api.nvim_set_hl(0, grp, { bg = bg })
							end
						end
					end

					set_git_sign_bgs()

					vim.api.nvim_create_autocmd({ "ColorScheme", "User" }, {
						pattern = { "*", "GitsignsAttach", "GitsignsDetach" },
						callback = set_git_sign_bgs,
					})
					-- vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#181820", fg = "#C8C093", bold = true })

					vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg, fg = colors.fg })
					vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "FloatTitle", { bg = colors.bg, fg = colors.border, bold = true })

					vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = colors.bg, fg = colors.border })

					vim.api.nvim_set_hl(0, "LspInfoBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = colors.bg })

					vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.bg_light, fg = colors.fg })
					vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.border, fg = colors.bg, bold = true })
					vim.api.nvim_set_hl(0, "PmenuBorder", { bg = colors.bg_light, fg = colors.border })
				end,
			})

			-- Trigger for current colorscheme
			vim.cmd("doautocmd ColorScheme")
		end,
	},
}
