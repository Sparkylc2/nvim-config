return {

	{
		"saghen/blink.cmp",
		lazy = false,
		version = "v1.*",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"honza/vim-snippets",
		},

		filetype_exclude = { "neo-tree", "harpoon", "copilot-chat", "TelescopePrompt", "lazy", "NvimTree" },
		opts = {
			enabled = function()
				local allowed_filetypes = {
					"lua",
					"python",
					"javascript",
					"typescript",
					"rust",
					"go",
					"c",
					"cpp",
					"java",
					"php",
					"ruby",
					"html",
					"css",
					"scss",
					"json",
					"yaml",
					"toml",
					"sh",
					"bash",
					"zsh",
					"vim",
					"markdown",
					"tex",
					"sql",
					"dockerfile",
					"javascriptreact",
					"typescriptreact",
					"vue",
					"svelte",
				}

				if vim.bo.buftype == "prompt" then
					return false
				end

				if not vim.tbl_contains(allowed_filetypes, vim.bo.filetype) then
					return false
				end

				if vim.b.completion == false then
					return false
				end

				return true
			end,

			fuzzy = {
				implementation = "prefer_rust_with_warning",
				-- Prefer exact and prefix matches over fuzzy matches
				prebuilt_binaries = {
					download = true,
				},
				-- CRITICAL: Add 'exact' first to always prioritize exact matches
				sorts = { "exact", "score", "sort_text" },
			},

			keymap = {
				preset = "enter",
				["<CR>"] = { "fallback" },
				["<S-CR>"] = { "accept" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<C-y>"] = { "select_and_accept" },

				["<A-S-n>"] = { "select_prev", "fallback" },

				["<A-N>"] = { "select_prev", "fallback" },
				["<A-n>"] = { "select_next", "fallback" },

				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<Tab>"] = { "snippet_forward", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "󰉿",
					Method = "󰊕",
					Function = "󰊕",
					Constructor = "󰒓",
					Field = "󰜢",
					Variable = "󰆦",
					Property = "󰖷",
					Class = "󱡠",
					Interface = "󱡠",
					Struct = "󱡠",
					Module = "󰅩",
					Unit = "󰪚",
					Value = "󰦨",
					Enum = "󰦨",
					EnumMember = "󰦨",
					Keyword = "󰻾",
					Constant = "󰏿",
					Snippet = "󱄽",
					Color = "󰏘",
					File = "󰈔",
					Reference = "󰬲",
					Folder = "󰉋",
					Event = "󱐋",
					Operator = "󰪚",
					TypeParameter = "󰬛",
				},
			},

			sources = {

				per_filetype = {
					lua = { "lsp", "buffer", "snippets", "path" },
					python = { "lsp", "buffer", "snippets", "path" },
					javascript = { "lsp", "buffer", "snippets", "path" },
					typescript = { "lsp", "buffer", "snippets", "path" },
					rust = { "lsp", "buffer", "snippets", "path" },
					go = { "lsp", "buffer", "snippets", "path" },
					c = { "lsp", "buffer", "snippets", "path" },
					cpp = { "lsp", "buffer", "snippets", "path" },
					java = { "lsp", "buffer", "snippets", "path" },
					php = { "lsp", "buffer", "snippets", "path" },
					ruby = { "lsp", "buffer", "snippets", "path" },
					html = { "lsp", "buffer", "snippets", "path" },
					css = { "lsp", "buffer", "snippets", "path" },
					scss = { "lsp", "buffer", "snippets", "path" },
					json = { "lsp", "buffer", "snippets", "path" },
					yaml = { "lsp", "buffer", "snippets", "path" },
					toml = { "lsp", "buffer", "snippets", "path" },
					sh = { "lsp", "buffer", "snippets", "path" },
					bash = { "lsp", "buffer", "snippets", "path" },
					zsh = { "lsp", "buffer", "snippets", "path" },
					vim = { "lsp", "buffer", "snippets", "path" },
					markdown = { "lsp", "buffer", "snippets", "path" },
					tex = { "lsp", "buffer", "snippets", "path" },
					sql = { "lsp", "buffer", "snippets", "path" },
					dockerfile = { "lsp", "buffer", "snippets", "path" },
					javascriptreact = { "lsp", "buffer", "snippets", "path" },
					typescriptreact = { "lsp", "buffer", "snippets", "path" },
					vue = { "lsp", "buffer", "snippets", "path" },
					svelte = { "lsp", "buffer", "snippets", "path" },
				},

				default = {},
				providers = {
					snippets = {
						name = "Snippets",
						module = "blink.cmp.sources.snippets",
						score_offset = 90, -- Increased for exact snippet matches
						opts = {
							friendly_snippets = true,
							search_paths = { vim.fn.stdpath("config") .. "/snippets" },
							global_snippets = { "all" },
							extended_filetypes = {},
							ignored_filetypes = {},
						},
					},
					lsp = {
						name = "LSP",
						module = "blink.cmp.sources.lsp",
						score_offset = 100, -- Highest for LSP (built-ins, imports, etc)
					},
					path = {
						name = "Path",
						module = "blink.cmp.sources.path",
						score_offset = 30, -- Lower priority for paths
						opts = {
							trailing_slash = false,
							label_trailing_slash = true,
							get_cwd = function()
								return vim.fn.getcwd()
							end,
							show_hidden_files_by_default = false,
						},
					},
					buffer = {
						name = "Buffer",
						module = "blink.cmp.sources.buffer",
						score_offset = 75, -- Reduced to let exact snippet matches win
						opts = {
							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end,
							max_indexed_line_length = 200,
							indexing_interval = 100,
						},
					},
				},
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				trigger = {
					prefetch_on_insert = false,
					show_on_insert_on_trigger_character = false,
				},
				menu = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					draw = {
						treesitter = { "lsp" },
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "source_name" },
						},
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					treesitter_highlighting = true,
					window = {
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
					},
				},
				ghost_text = { enabled = vim.g.ai_cmp or false },
			},

			signature = {
				enabled = true,
				window = {
					border = "rounded",
					winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				},
			},
		},

		opts_extend = { "sources.default" },
		config = function(_, opts)
			require("blink.cmp").setup(opts)

			local c = {
				bg = "#0d0c0c",
				bg_dim = "#181616",
				bg_light = "#282727",
				fg = "#c5c9c5",
				fg_dim = "#a6a69c",
				blue = "#8ba4b0",
				purple = "#a292a3",
				green = "#8a9a7b",
				yellow = "#c4b28a",
				orange = "#b6927b",
				red = "#c4746e",
				teal = "#8ea4a2",
			}
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = c.bg_light, fg = c.fg })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = c.bg_light, fg = c.bg_light })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = c.blue, fg = c.bg, bold = true })
			vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = c.bg_dim, fg = c.fg })
			vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = c.bg_dim, fg = c.bg_dim })
			vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = c.bg_dim, fg = c.fg })
			vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { bg = c.bg_dim, fg = c.bg_dim })

			vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = c.fg })
			vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = c.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = c.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = c.orange })
			vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = c.teal })
			vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = c.purple })
			vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = c.orange })
			vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = c.teal })
			vim.api.nvim_set_hl(0, "BlinkCmpKindUnit", { fg = c.green })
			vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = c.purple })
			vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = c.red })
			vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = c.green })
			vim.api.nvim_set_hl(0, "BlinkCmpKindColor", { fg = c.teal })
			vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { fg = c.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpKindReference", { fg = c.purple })
			vim.api.nvim_set_hl(0, "BlinkCmpKindFolder", { fg = c.blue })
			vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = c.teal })
			vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = c.orange })
			vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "BlinkCmpKindEvent", { fg = c.orange })
			vim.api.nvim_set_hl(0, "BlinkCmpKindOperator", { fg = c.red })
			vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = c.fg_dim, italic = true })
		end,
	},
}
