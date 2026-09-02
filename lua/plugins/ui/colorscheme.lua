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

					vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg, fg = colors.fg })
					vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.bg, fg = colors.border })
					vim.api.nvim_set_hl(0, "FloatTitle", { bg = colors.bg, fg = colors.border, bold = true })

					-- snacks.picker replaced telescope; these are its groups
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

						-- other snacks surfaces, same palette
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
					-- Splits should be invisible: the separator, the sign column and
					-- the number column all sit on the same background, so a split
					-- reads as one continuous surface rather than two panes with a
					-- rule between them.
					colors.apply({
						WinSeparator = { fg = colors.bg, bg = colors.bg },
						VertSplit = { fg = colors.bg, bg = colors.bg },

						-- snacks.words calls vim.lsp.buf.document_highlight(),
						-- which highlights every reference of the symbol under the
						-- cursor. Blanking these groups removes the highlight but
						-- keeps the extmarks, so ]] / [[ still jump between them.
						-- To drop the feature entirely instead, set
						-- words = { enabled = false } in plugins/ui/snacks.lua.
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
