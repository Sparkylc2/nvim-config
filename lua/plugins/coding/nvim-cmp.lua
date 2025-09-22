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
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"honza/vim-snippets",
			"L3MON4D3/LuaSnip",
			"lervag/vimtex",
			"hrsh7th/cmp-omni",
			"onsails/lspkind.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

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

			vim.api.nvim_set_hl(0, "CmpMenu", { bg = c.bg_dim, fg = c.bg_dim })
			vim.api.nvim_set_hl(0, "CmpBorder", { bg = c.bg_dim, fg = c.orange })
			vim.api.nvim_set_hl(0, "CmpSel", { bg = c.blue, fg = c.bg, bold = true })
			vim.api.nvim_set_hl(0, "CmpDoc", { bg = c.bg_dim, fg = c.fg })
			vim.api.nvim_set_hl(0, "CmpDocBorder", { bg = c.bg_dim, fg = c.orange })

			vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = c.fg })
			vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = c.fg_dim, strikethrough = true })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = c.blue, bold = true })
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = c.blue })
			vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = c.fg_dim, italic = true })

			vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = c.fg })
			vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = c.blue })
			vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = c.blue })
			vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = c.orange })
			vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = c.teal })
			vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = c.purple })
			vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = c.orange })
			vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = c.teal })
			vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = c.green })
			vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = c.purple })
			vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = c.red })
			vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = c.green })
			vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = c.teal })
			vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = c.blue })
			vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = c.purple })
			vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = c.blue })
			vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = c.teal })
			vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = c.orange })
			vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = c.yellow })
			vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = c.orange })
			vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = c.red })
			vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = c.yellow })

			vim.o.pumheight = 5

			local function deprioritize_snippet(entry1, entry2)
				local kind1 = entry1:get_kind()
				local kind2 = entry2:get_kind()
				if kind1 == 15 and kind2 ~= 15 then
					return false
				elseif kind2 == 15 and kind1 ~= 15 then
					return true
				end
			end

			cmp.setup({

				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol",
						maxwidth = { menu = 50, abbr = 50 },
						ellipsis_char = "...",
						show_labelDetails = true,
					}),
				},

				preselect = cmp.PreselectMode.Item,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				enabled = function()
					if vim.api.nvim_get_mode().mode == "c" then
						return false
					end

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

					local context = require("cmp.config.context")
					return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
				end,
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<S-CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.confirm({ select = true }),
					["<C-h>"] = cmp.mapping.close(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<A-u>"] = cmp.mapping.select_next_item(),
					["<A-S-u>"] = cmp.mapping.select_prev_item(),

					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "luasnip", priority = 20, keyword_length = 2 },
					{ name = "nvim_lsp", priority = 80 },
					{ name = "path", priority = 40 },
					{ name = "buffer", priority = 10 },
				}),

				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:CmpMenu,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
						side_padding = 0,
						scrollbar = false,
					}),
					documentation = cmp.config.window.bordered({
						border = "rounded",
						winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder",
					}),
				},

				experimental = {
					ghost_text = vim.g.ai_cmp or false,
				},

				sorting = {
					priority_weight = 1.0,
					comparators = {
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						deprioritize_snippet,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})

			cmp.setup.filetype("tex", {
				sources = cmp.config.sources({
					{ name = "omni" },
					{ name = "luasnip", priority = 20, keyword_length = 2 },
					{ name = "nvim_lsp", priority = 80 },
					{ name = "path", priority = 40 },
					{ name = "buffer", priority = 10 },
				}),
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
			})
		end,
	},
}
