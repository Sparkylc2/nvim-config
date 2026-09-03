return {
	{
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
			})

			vim.cmd("colorscheme kanagawa-dragon")
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					local colors = require("config.palette")
					vim.api.nvim_set_hl(0, "SignColumn", { bg = "#181616" })
					vim.api.nvim_set_hl(0, "LineNr", { bg = "#181616", fg = "#625E5A" })
					colors.apply({
						-- signs
						DiagnosticSignError = { bg = colors.bg, fg = colors.error },
						DiagnosticSignWarn = { bg = colors.bg, fg = colors.warn },
						DiagnosticSignInfo = { bg = colors.bg, fg = colors.info },
						DiagnosticSignHint = { bg = colors.bg, fg = colors.hint },
						DiagnosticSignOk = { bg = colors.bg, fg = colors.ok },

						-- virtual text and floats
						DiagnosticError = { fg = colors.error },
						DiagnosticWarn = { fg = colors.warn },
						DiagnosticInfo = { fg = colors.info },
						DiagnosticHint = { fg = colors.hint },
						DiagnosticOk = { fg = colors.ok },

						DiagnosticVirtualTextError = { fg = colors.error, bg = "NONE" },
						DiagnosticVirtualTextWarn = { fg = colors.warn, bg = "NONE" },
						DiagnosticVirtualTextInfo = { fg = colors.info, bg = "NONE" },
						DiagnosticVirtualTextHint = { fg = colors.hint, bg = "NONE" },

						-- undercurls
						DiagnosticUnderlineError = { undercurl = true, sp = colors.error },
						DiagnosticUnderlineWarn = { undercurl = true, sp = colors.warn },
						DiagnosticUnderlineInfo = { undercurl = true, sp = colors.info },
						DiagnosticUnderlineHint = { undercurl = true, sp = colors.hint },

						-- soft yank flash
						YankFlash = { bg = colors.yank_bg },
					})

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

					vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg, fg = colors.fg })
					vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "FloatTitle", { bg = colors.bg, fg = colors.border, bold = true })

					-- snacks.picker
					colors.apply({
						SnacksPickerNormal = { bg = colors.bg, fg = colors.fg },
						SnacksPickerBorder = { bg = colors.bg, fg = colors.border },
						SnacksPickerTitle = { bg = colors.bg, fg = colors.border, bold = true },
						SnacksPickerInput = { bg = colors.bg },
						SnacksPickerInputBorder = { bg = colors.bg, fg = colors.border },
						SnacksPickerList = { bg = colors.bg },
						SnacksPickerListBorder = { bg = colors.bg, fg = colors.border },
						SnacksPickerPreview = { bg = colors.bg },
						SnacksPickerPreviewBorder = { bg = colors.bg, fg = colors.border },
						SnacksPickerMatch = { fg = colors.blue, bold = true },
						SnacksPickerCursorLine = { bg = colors.bg_light },

						-- other snacks surfaces
						SnacksNotifierBorderInfo = { bg = colors.bg, fg = colors.border },
						SnacksNotifierBorderWarn = { bg = colors.bg, fg = colors.yellow },
						SnacksNotifierBorderError = { bg = colors.bg, fg = colors.red },
						SnacksInputBorder = { bg = colors.bg, fg = colors.border },
						SnacksIndent = { fg = colors.bg_light },
						SnacksIndentScope = { fg = colors.gray },
						SnacksDashboardHeader = { fg = colors.blue },
						SnacksDashboardIcon = { fg = colors.orange },
						SnacksDashboardKey = { fg = colors.yellow },
						SnacksDashboardDesc = { fg = colors.fg },
						SnacksDashboardFooter = { fg = colors.gray, italic = true },
					})

					vim.api.nvim_set_hl(0, "LspInfoBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { bg = colors.bg })
					vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { bg = colors.bg })

					vim.api.nvim_set_hl(0, "Pmenu", { bg = colors.bg_light, fg = colors.fg })
					vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.border, fg = colors.bg, bold = true })
					vim.api.nvim_set_hl(0, "PmenuBorder", { bg = colors.bg_light, fg = colors.border })
					colors.apply({
						WinSeparator = { fg = colors.blend(colors.bg_light, colors.gray, 0.9), bg = colors.bg },
						VertSplit = { fg = colors.blend(colors.bg_light, colors.gray, 0.9), bg = colors.bg },

						LspReferenceText = {},
						LspReferenceRead = {},
						LspReferenceWrite = {},
						SnacksWordsText = {},
						SnacksWordsRead = {},
						SnacksWordsWrite = {},
					})
				end,
			})

			-- Trigger for current colorscheme
			vim.cmd("doautocmd ColorScheme")
		end,
	},
}
