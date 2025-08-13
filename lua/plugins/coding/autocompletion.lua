-- return {
-- 	{
-- 		"hrsh7th/nvim-cmp",
-- 		event = "InsertEnter",
-- 		dependencies = {
-- 			"L3MON4D3/LuaSnip",
-- 			"saadparwaiz1/cmp_luasnip",
-- 			"hrsh7th/cmp-nvim-lsp",
-- 			"hrsh7th/cmp-buffer",
-- 			"hrsh7th/cmp-path",
-- 			"rafamadriz/friendly-snippets",
-- 		},
-- 		config = function()
-- 			local cmp = require("cmp")
-- 			local luasnip = require("luasnip")
--
-- 			require("luasnip.loaders.from_vscode").lazy_load()
-- 			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })
--
-- 			local has_words_before = function()
-- 				unpack = unpack or table.unpack
-- 				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
-- 				return col ~= 0
-- 					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
-- 			end
--
-- 			local has_interacted = false
--
-- 			cmp.event:on("menu_opened", function()
-- 				has_interacted = false
-- 			end)
--
-- 			cmp.event:on("menu_closed", function()
-- 				has_interacted = false
-- 			end)
--
-- 			cmp.event:on("cursor_moved", function()
-- 				has_interacted = true
-- 			end)
-- 			cmp.setup({
-- 				snippet = {
-- 					expand = function(args)
-- 						luasnip.lsp_expand(args.body)
-- 					end,
-- 				},
-- 				window = {
-- 					completion = cmp.config.window.bordered(),
-- 					documentation = cmp.config.window.bordered(),
-- 				},
--
-- 				mapping = cmp.mapping.preset.insert({
-- 					["<C-k>"] = cmp.mapping.select_prev_item(),
-- 					["<C-j>"] = cmp.mapping.select_next_item(),
-- 					["<C-b>"] = cmp.mapping.scroll_docs(-4),
-- 					["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 					["<C-Space>"] = cmp.mapping.complete(),
-- 					["<C-e>"] = cmp.mapping.abort(),
-- 					["<S-CR>"] = cmp.mapping(function(fallback)
-- 						if not has_interacted then
-- 							if cmp.visible() then
-- 								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
-- 								cmp.confirm({
-- 									select = false,
-- 									behavior = cmp.ConfirmBehavior.Replace,
-- 								})
-- 								cmp.confirm({ select = false })
-- 							elseif luasnip.expandable() then
-- 								luasnip.expand()
-- 							end
-- 							fallback()
-- 						else
-- 							fallback()
-- 						end
-- 					end, { "i", "s" }),
-- 					["<CR>"] = cmp.mapping(function(fallback)
-- 						if cmp.visible() and has_interacted then
-- 							cmp.confirm({ select = false })
-- 						else
-- 							fallback()
-- 						end
-- 					end, { "i", "s" }),
-- 					-- Tab navigation
-- 					["<Tab>"] = cmp.mapping(function(fallback)
-- 						if luasnip.jumpable(1) then
-- 							luasnip.jump(1)
-- 						elseif luasnip.expandable() then
-- 							luasnip.expand()
-- 						elseif cmp.visible() and has_interacted then
-- 							cmp.select_prev_item()
-- 						else
-- 							fallback()
-- 						end
-- 					end, { "i", "s" }),
-- 					["<S-Tab>"] = cmp.mapping(function(fallback)
-- 						if luasnip.jumpable(-1) then
-- 							luasnip.jump(-1)
-- 						elseif cmp.visible() and not has_interacted then
-- 							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
-- 							has_interacted = true
-- 						elseif cmp.visible() then
-- 							cmp.select_next_item()
-- 						else
-- 							fallback()
-- 						end
-- 					end, { "i", "s" }),
-- 				}),
-- 				sources = cmp.config.sources({
-- 					{ name = "luasnip", priority = 1000 },
-- 					{ name = "nvim_lsp", priority = 900 },
-- 					{ name = "buffer", priority = 500 },
-- 					{ name = "path", priority = 300 },
-- 				}),
-- 				sorting = {
-- 					priority_weight = 2,
-- 					comparators = {
-- 						cmp.config.compare.offset,
-- 						cmp.config.compare.exact,
-- 						cmp.config.compare.score,
-- 						cmp.config.compare.recently_used,
-- 						cmp.config.compare.kind,
-- 						cmp.config.compare.sort_text,
-- 						cmp.config.compare.length,
-- 						cmp.config.compare.order,
-- 					},
-- 				},
-- 			})
--
-- 			-- Setup autopairs with cmp
-- 			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
-- 			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
-- 		end,
-- 	},
-- }

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local has_interacted = false
			cmp.event:on("menu_opened", function()
				has_interacted = false
			end)
			cmp.event:on("menu_closed", function()
				has_interacted = false
			end)
			cmp.event:on("cursor_moved", function()
				has_interacted = true
			end)

			luasnip.config.setup({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
				ext_opts = {
					[require("luasnip.util.types").choiceNode] = {
						active = {
							virt_text = { { "choiceNode", "Comment" } },
						},
					},
				},
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() and has_interacted then
							cmp.confirm({
								select = false,
								behavior = cmp.ConfirmBehavior.Replace,
							})
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() and not has_interacted and not luasnip.in_snippet() then
							cmp.confirm({
								select = true,
								behavior = cmp.ConfirmBehavior.Insert,
							})
						elseif cmp.visible() and has_interacted then
							cmp.select_prev_item()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						elseif luasnip.expandable() then
							luasnip.expand()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() and not has_interacted then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							has_interacted = true
						elseif cmp.visible() and has_interacted then
							cmp.select_next_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip", priority = 1000 },
					{ name = "nvim_lsp", priority = 999 },
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 300 },
				}),
				confirmation = {
					default_behavior = cmp.ConfirmBehavior.Insert,
				},

				sorting = {
					priority_weight = 2,
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
			})
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
}
