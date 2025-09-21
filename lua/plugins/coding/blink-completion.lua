return {
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
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
		lazy = false,
		dependencies = {
			"rafamadriz/friendly-snippets",
			"honza/vim-snippets",
			"L3MON4D3/LuaSnip",
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

			snippets = {
				preset = "luasnip",
			},

			fuzzy = {
				implementation = "prefer_rust_with_warning",
				prebuilt_binaries = { download = true },
				sorts = { "exact", "score", "sort_text" },
			},

			keymap = {
				preset = "enter",
				["<CR>"] = { "fallback" },
				["<S-CR>"] = { "accept" },
				["<S-space>"] = { "accept", "fallback" },
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-h>"] = { "hide" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-y>"] = { "select_and_accept" },
				["<A-l>"] = { "select_prev", "fallback" },
				["<A-H>"] = { "select_prev", "fallback" },
				["<A-h>"] = { "select_next", "fallback" },
				["<A-u>"] = { "select_next", "fallback" },
				["<Tab>"] = { "snippet_forward", "accept", "fallback" },
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
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						score_offset = 100, -- High priority for snippets
					},
					lsp = {
						score_offset = 50,
					},
					buffer = {
						score_offset = 10, -- Lower priority for buffer matches
					},
					path = {
						score_offset = 20,
					},
				},
				-- Boost snippet scores for exact matches
				transform_items = function(_, items)
					local input = vim.v.completed_item and vim.v.completed_item.word or ""
					if input == "" then
						-- Get current line and cursor position to extract the current input
						local line = vim.api.nvim_get_current_line()
						local col = vim.api.nvim_win_get_cursor(0)[2]
						-- Extract word before cursor
						local before_cursor = line:sub(1, col)
						input = before_cursor:match("%w+$") or ""
					end

					for _, item in ipairs(items) do
						-- Boost snippet scores significantly for exact prefix matches
						if item.source_name == "snippets" then
							if item.label and input ~= "" and item.label:lower():find("^" .. input:lower()) then
								item.score_offset = (item.score_offset or 0) + 1000
							end
						end
					end
					return items
				end,
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
