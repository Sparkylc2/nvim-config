return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {},

	config = function()
		require("render-markdown").setup({
			anti_conceal = {
				enabled = true,
				ignore = {
					latex = true,
				},
			},
			checkbox = {
				enabled = true,
				render_modes = false,
				bullet = false,
				left_pad = 0,
				right_pad = 1,

				unchecked = {
					icon = "󰄱 ",
					highlight = "RenderMarkdownUnchecked",
					scope_highlight = nil,

					vim.api.nvim_set_hl(0, "RenderMarkdownUnchecked", { fg = "#7c96cb" }),
				},
				checked = {
					icon = "󰱒 ",
					highlight = "RenderMarkdownChecked",
					scope_highlight = nil,

					vim.api.nvim_set_hl(0, "RenderMarkdownChecked", { fg = "#25b2bc" }),
				},
				custom = {
					todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
					star = { raw = "[~]", rendered = "󰓎 ", highlight = "RenderMarkdownStar", scope_highlight = nil },
					warn = {
						raw = "[!]",
						rendered = "󰀪 ",
						highlight = "RenderMarkdownWarning",
						scope_highlight = nil,
					},

					vim.api.nvim_set_hl(0, "RenderMarkdownTodo", { fg = "#97bc71" }),
					vim.api.nvim_set_hl(0, "RenderMarkdownStar", { fg = "#ffc24b" }),
					vim.api.nvim_set_hl(0, "RenderMarkdownWarning", { fg = "#f43753" }),
				},
				scope_priority = nil,
			},

			latex = {
				enabled = false,
			},

			heading = {
				enabled = true,
				render_modes = false,
				atx = true,
				setext = true,
				sign = false,
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				position = "inline",
				signs = { "󰫎 " },
				width = "full",
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				border = false,
				border_virtual = false,
				border_prefix = false,
				above = "▄",
				below = "▀",
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH2Bg",
					"RenderMarkdownH3Bg",
					"RenderMarkdownH4Bg",
					"RenderMarkdownH5Bg",
					"RenderMarkdownH6Bg",
				},
				foregrounds = {
					"RenderMarkdownH1",
					"RenderMarkdownH2",
					"RenderMarkdownH3",
					"RenderMarkdownH4",
					"RenderMarkdownH5",
					"RenderMarkdownH6",
				},
				custom = {},
			},
		})
	end,
}

-- return {
-- 	"OXY2DEV/markview.nvim",
-- 	enabled = false,
-- 	event = "VeryLazy",
-- 	ft = { "markdown", "md", "rmd", "quarto" },
-- 	config = function()
-- 		local presets = require("markview.presets")
--
-- 		require("markview").setup({
-- 			preview = {
-- 				icon_provider = "devicons",
--
-- 				filetypes = { "md", "rmd", "quarto", "markdown" },
--
-- 				modes = { "n", "no", "c" },
--
-- 				hybrid_modes = { "i", "v" },
--
-- 				debounce = 50,
-- 			},
--
-- 			markdown = {
-- 				headings = presets.headings.slanted,
--
-- 				horizontal_rules = presets.horizontal_rules.thick,
--
-- 				code_blocks = {
-- 					style = "language",
-- 					position = "overlay",
-- 					min_width = 60,
-- 					pad_amount = 2,
-- 				},
--
-- 				list_items = {
-- 					enable = true,
-- 					shift_width = 2,
-- 				},
-- 			},
--
-- 			markdown_inline = {
-- 				enable = true,
--
-- 				checkboxes = {
-- 					enable = true,
-- 					checked = { text = "✓", hl = "MarkviewCheckboxChecked" },
-- 					unchecked = { text = "○", hl = "MarkviewCheckboxUnchecked" },
-- 					pending = { text = "◐", hl = "MarkviewCheckboxPending" },
-- 					cancelled = { text = "✗", hl = "MarkviewCheckboxCancelled" },
-- 				},
--
-- 				inline_codes = {
-- 					enable = true,
-- 					corner_left = " ",
-- 					corner_right = " ",
-- 					padding_left = " ",
-- 					padding_right = " ",
-- 				},
--
-- 				hyperlinks = {
-- 					enable = true,
-- 				},
-- 			},
-- 		})
--
-- 		local opts = { noremap = true, silent = true }
--
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>mt",
-- 			"<cmd>Markview Toggle<CR>",
-- 			vim.tbl_extend("force", opts, { desc = "Toggle Markdown view" })
-- 		)
--
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>mh",
-- 			"<cmd>Markview HybridToggle<CR>",
-- 			vim.tbl_extend("force", opts, { desc = "Toggle hybrid mode" })
-- 		)
--
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>ms",
-- 			"<cmd>Markview splitToggle<CR>",
-- 			vim.tbl_extend("force", opts, { desc = "Toggle split view" })
-- 		)
--
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>mr",
-- 			"<cmd>Markview render<CR>",
-- 			vim.tbl_extend("force", opts, { desc = "Force render markdown" })
-- 		)
--
-- 		vim.keymap.set(
-- 			"n",
-- 			"<leader>mc",
-- 			"<cmd>Markview clear<CR>",
-- 			vim.tbl_extend("force", opts, { desc = "Clear markdown preview" })
-- 		)
--
-- 		require("markview.extras.checkboxes").setup({
-- 			default_marker = "-",
-- 			enable_cursor_move = true,
-- 			checkbox_chars = {
-- 				checked = "x",
-- 				unchecked = " ",
-- 				pending = "!",
-- 				cancelled = "~",
-- 			},
-- 		})
--
-- 		vim.keymap.set("n", "<leader>mx", function()
-- 			require("markview.extras.checkboxes").toggle()
-- 		end, vim.tbl_extend("force", opts, { desc = "Toggle checkbox" }))
--
-- 		vim.keymap.set("n", "<leader>mi", function()
-- 			vim.cmd("Checkbox interactive")
-- 		end, vim.tbl_extend("force", opts, { desc = "Interactive checkbox mode" }))
--
-- 		local function apply_markview_highlights()
-- 			local highlights = {
-- 				MarkviewPalette1 = { fg = "#ff6b6b", bg = "#2d2d2d" },
-- 				MarkviewPalette2 = { fg = "#4ecdc4", bg = "#2d2d2d" },
-- 				MarkviewPalette3 = { fg = "#45b7d1", bg = "#2d2d2d" },
-- 				MarkviewPalette4 = { fg = "#96ceb4", bg = "#2d2d2d" },
-- 				MarkviewPalette5 = { fg = "#ffeaa7", bg = "#2d2d2d" },
-- 				MarkviewPalette6 = { fg = "#dda0dd", bg = "#2d2d2d" },
--
-- 				MarkviewHeading1 = { fg = "#ff6b6b", bold = true },
-- 				MarkviewHeading2 = { fg = "#4ecdc4", bold = true },
-- 				MarkviewHeading3 = { fg = "#45b7d1", bold = true },
-- 				MarkviewHeading4 = { fg = "#96ceb4", bold = true },
-- 				MarkviewHeading5 = { fg = "#ffeaa7", bold = true },
-- 				MarkviewHeading6 = { fg = "#dda0dd", bold = true },
--
-- 				MarkviewCheckboxChecked = { fg = "#96ceb4", bold = true }, -- Green
-- 				MarkviewCheckboxUnchecked = { fg = "#ff6b6b", bold = true }, -- Red
-- 				MarkviewCheckboxPending = { fg = "#ffeaa7", bold = true }, -- Yellow
-- 				MarkviewCheckboxCancelled = { fg = "#666666", bold = true }, -- Gray
-- 				MarkviewCheckboxProgress = { fg = "#45b7d1", bold = true }, -- Blue
-- 				MarkviewCheckboxStriked = { fg = "#666666", strikethrough = true },
--
-- 				MarkviewListItemMinus = { fg = "#ff6b6b", bold = true }, -- Red
-- 				MarkviewListItemPlus = { fg = "#96ceb4", bold = true }, -- Green
-- 				MarkviewListItemStar = { fg = "#ffeaa7", bold = true }, -- Yellow
--
-- 				MarkviewHyperlink = { fg = "#45b7d1", underline = true }, -- Blue
-- 				MarkviewImage = { fg = "#dda0dd", bold = true }, -- Purple
-- 				MarkviewEmail = { fg = "#4ecdc4", underline = true }, -- Teal
--
-- 				MarkviewTableHeader = { fg = "#ffeaa7", bold = true }, -- Yellow
-- 				MarkviewTableBorder = { fg = "#666666" }, -- Gray
--
-- 				MarkviewCode = { bg = "#1e1e1e", fg = "#e4e4e4" },
-- 				MarkviewInlineCode = { bg = "#2d2d2d", fg = "#ff9500" },
-- 			}
--
-- 			for group, opts in pairs(highlights) do
-- 				vim.api.nvim_set_hl(0, group, opts)
-- 			end
-- 		end
--
-- 		local markview_group = vim.api.nvim_create_augroup("MarkviewConfig", { clear = true })
--
-- 		vim.api.nvim_create_autocmd("ColorScheme", {
-- 			group = markview_group,
-- 			callback = function()
-- 				vim.schedule(function()
-- 					apply_markview_highlights()
-- 					vim.cmd("Markview render")
-- 				end)
-- 			end,
-- 		})
--
-- 		vim.api.nvim_create_autocmd("VimEnter", {
-- 			group = markview_group,
-- 			callback = function()
-- 				vim.schedule(function()
-- 					apply_markview_highlights()
-- 				end)
-- 			end,
-- 		})
--
-- 		vim.api.nvim_create_autocmd("FileType", {
-- 			group = markview_group,
-- 			pattern = { "markdown", "md", "rmd", "quarto" },
-- 			callback = function()
-- 				vim.schedule(function()
-- 					apply_markview_highlights()
-- 					vim.cmd("Markview enable")
-- 				end)
-- 			end,
-- 		})
-- 	end,
-- }
