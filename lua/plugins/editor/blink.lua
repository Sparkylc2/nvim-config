local p = require("config.palette")

return {
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
			{ "saghen/blink.compat", version = "2.*", opts = {} },
			"hrsh7th/cmp-omni",
		},

		opts = {
			snippets = { preset = "luasnip" },
			keymap = {
				preset = "none",
				-- kitty maps cmd+enter -> ctrl+j, so this IS cmd+enter.
				-- <CR> is deliberately left unbound: Enter should insert a
				-- newline, never accept a completion.
				["<C-j>"] = { "accept", "fallback" },
				["<C-h>"] = { "hide", "fallback" },
				["<A-u>"] = { "select_next", "fallback" },
				["<A-l>"] = { "select_prev", "fallback" },
				["<A-U>"] = { "scroll_documentation_up", "fallback" },
				["<A-L>"] = { "scroll_documentation_down", "fallback" },
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
					-- cmd+enter accepts the highlighted item without running it;
					-- plain Enter is left alone so it executes the command line
					["<C-j>"] = { "accept", "fallback" },
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
					-- note: blink disables the scrollbar *gutter* when a border is
					-- set, so only the thumb draws -- it rides the rounded border
					-- itself, which is the rounded look you wanted
					scrollbar = true,
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
						score_offset = -1,
						min_keyword_length = 2,
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
				-- Matching the old cmp exactly: the menu sat on bg_dim (#181616,
				-- i.e. the editor background), NOT on bg (#0d0c0c). Only the
				-- selected row's text used the darker one.
				BlinkCmpMenu = { bg = p.bg, fg = p.fg },
				BlinkCmpMenuBorder = { bg = p.bg, fg = p.orange },
				BlinkCmpMenuSelection = { bg = p.blue, fg = p.bg_dark, bold = true },
				BlinkCmpDoc = { bg = p.bg, fg = p.fg },
				BlinkCmpDocBorder = { bg = p.bg, fg = p.orange },
				BlinkCmpDocSeparator = { bg = p.bg, fg = p.orange },

				BlinkCmpLabel = { bg = p.bg, fg = p.fg },
				BlinkCmpLabelDeprecated = { bg = p.bg, fg = p.fg_dim, strikethrough = true },
				BlinkCmpLabelMatch = { bg = p.bg, fg = p.blue, bold = true },

				-- LabelDetail is the "() const" / signature half of each entry.
				-- Left undefined it links to PmenuExtra, which in this theme has
				-- a blue background -- that is where the blue second half came
				-- from. bg is set explicitly on all of these so none of them can
				-- fall back to a group with its own background.
				BlinkCmpLabelDetail = { bg = p.bg, fg = p.fg_dim },
				BlinkCmpLabelDescription = { bg = p.bg, fg = p.fg_dim, italic = true },
				BlinkCmpSource = { bg = p.bg, fg = p.fg_dim, italic = true },
				BlinkCmpKind = { bg = p.bg, fg = p.fg_dim },
				BlinkCmpGhostText = { bg = p.bg, fg = p.gray, italic = true },
				BlinkCmpScrollBarThumb = { bg = p.blue, fg = p.blue },
				BlinkCmpScrollBarGutter = { bg = p.bg, fg = p.bg },

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
