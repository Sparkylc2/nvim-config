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
