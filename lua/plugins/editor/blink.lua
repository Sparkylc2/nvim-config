-- blink.cmp, replacing nvim-cmp + cmp-nvim-lsp + cmp-buffer + cmp-path +
-- cmp-cmdline + cmp_luasnip + cmp-omni + lspkind (8 plugins -> 2).
--
-- blink.compat is required for exactly one thing: vimtex's completion is a
-- vimscript omnifunc with no lua source, so cmp-omni has to be run inside blink.
-- Everything else uses blink's native sources.

local p = require("config.palette")

return {
	-- LuaSnip keeps its own spec: the loaders below are what pull in
	-- lua/snippets (488 lines of LaTeX maths among them), and they used to live
	-- in the nvim-cmp file. Losing them would silently lose every snippet.
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = { "rafamadriz/friendly-snippets", "honza/vim-snippets" },
		config = function()
			require("luasnip.loaders.from_lua").lazy_load({
				paths = vim.fn.stdpath("config") .. "/lua/snippets",
			})
			require("luasnip.loaders.from_snipmate").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			-- shim so blink can run nvim-cmp sources; only cmp-omni needs it
			{ "saghen/blink.compat", version = "2.*", opts = {} },
			"hrsh7th/cmp-omni",
		},

		opts = {
			snippets = { preset = "luasnip" },

			keymap = {
				preset = "none",
				["<C-j>"] = { "accept", "fallback" },
				["<C-h>"] = { "hide", "fallback" },
				["<A-u>"] = { "select_next", "fallback" },
				["<A-l>"] = { "select_prev", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<Tab>"] = { "snippet_forward", "accept", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},

			cmdline = {
				keymap = {
					preset = "none",
					["<A-u>"] = { "select_next", "fallback" },
					["<A-l>"] = { "select_prev", "fallback" },
					["<Tab>"] = { "show", "select_next", "fallback" },
					["<S-Tab>"] = { "select_prev", "fallback" },
					["<CR>"] = { "accept_and_enter", "fallback" },
					["<C-h>"] = { "hide", "fallback" },
				},
				completion = { menu = { auto_show = true } },
			},

			completion = {
				list = { selection = { preselect = true, auto_insert = false } },
				accept = { auto_brackets = { enabled = true } },

				menu = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					scrollbar = false,
					draw = {
						-- kind icon, label, then source -- the lspkind layout
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
						},
					},
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
					},
				},
			},

			signature = {
				enabled = false, -- lsp_signature.nvim still owns this
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },

				-- The per-filetype answer to "snippets first in LaTeX, real
				-- symbols first in C++". score_offset biases the fuzzy score
				-- rather than hard-ordering, so a strong LSP match can still beat
				-- a weak snippet.
				per_filetype = {
					tex = { "snippets", "omni", "lsp", "path" },
					plaintex = { "snippets", "omni", "lsp", "path" },
					markdown = { "snippets", "lsp", "path", "buffer" },
				},

				providers = {
					lsp = { score_offset = 0 },
					path = { score_offset = -3 },
					buffer = { score_offset = -5 },
					snippets = {
						score_offset = -1, -- default: below LSP, as in C/C++
					},
					omni = {
						name = "omni",
						module = "blink.compat.source",
						score_offset = 20,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},

		config = function(_, opts)
			require("blink.cmp").setup(opts)

			-- Same palette as the old nvim-cmp block, via config.palette.
			p.apply({
				BlinkCmpMenu = { bg = p.bg_dark, fg = p.fg },
				BlinkCmpMenuBorder = { bg = p.bg_dark, fg = p.orange },
				BlinkCmpMenuSelection = { bg = p.blue, fg = p.bg_dark, bold = true },
				BlinkCmpDoc = { bg = p.bg_dark, fg = p.fg },
				BlinkCmpDocBorder = { bg = p.bg_dark, fg = p.orange },
				BlinkCmpDocSeparator = { bg = p.bg_dark, fg = p.orange },

				BlinkCmpLabel = { fg = p.fg },
				BlinkCmpLabelDeprecated = { fg = p.fg_dim, strikethrough = true },
				BlinkCmpLabelMatch = { fg = p.blue, bold = true },
				BlinkCmpLabelDescription = { fg = p.fg_dim, italic = true },
				BlinkCmpSource = { fg = p.fg_dim, italic = true },

				BlinkCmpKindText = { fg = p.fg },
				BlinkCmpKindMethod = { fg = p.blue },
				BlinkCmpKindFunction = { fg = p.blue },
				BlinkCmpKindConstructor = { fg = p.orange },
				BlinkCmpKindField = { fg = p.teal },
				BlinkCmpKindVariable = { fg = p.magenta },
				BlinkCmpKindClass = { fg = p.yellow },
				BlinkCmpKindInterface = { fg = p.yellow },
				BlinkCmpKindModule = { fg = p.orange },
				BlinkCmpKindProperty = { fg = p.teal },
				BlinkCmpKindUnit = { fg = p.green },
				BlinkCmpKindValue = { fg = p.magenta },
				BlinkCmpKindEnum = { fg = p.yellow },
				BlinkCmpKindKeyword = { fg = p.red },
				BlinkCmpKindSnippet = { fg = p.green },
				BlinkCmpKindColor = { fg = p.teal },
				BlinkCmpKindFile = { fg = p.blue },
				BlinkCmpKindReference = { fg = p.magenta },
				BlinkCmpKindFolder = { fg = p.blue },
				BlinkCmpKindEnumMember = { fg = p.teal },
				BlinkCmpKindConstant = { fg = p.orange },
				BlinkCmpKindStruct = { fg = p.yellow },
				BlinkCmpKindEvent = { fg = p.orange },
				BlinkCmpKindOperator = { fg = p.red },
				BlinkCmpKindTypeParameter = { fg = p.yellow },
			})
		end,
	},
}
