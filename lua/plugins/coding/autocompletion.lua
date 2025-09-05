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
			"honza/vim-snippets",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/snippets" })

			local user_interacted = false

			cmp.event:on("menu_opened", function()
				user_interacted = false
			end)
			cmp.event:on("cursor_moved", function()
				user_interacted = true
			end)

			local function has_words_before()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_get_current_line():sub(col, col):match("%s") == nil
			end

			local function can_jump_forward()
				return luasnip.expand_or_jumpable() and luasnip.locally_jumpable(1)
			end

			local function can_jump_backward()
				return luasnip.locally_jumpable(-1)
			end

			luasnip.config.setup({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				region_check_events = "CursorHold,InsertEnter",
				delete_check_events = "TextChanged,InsertLeave",
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
				performance = {
					debounce = 0,
					throttle = 0,
				},
				completion = {
					keyword_length = 2,
					autocomplete = { "TextChanged" },
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })
						else
							fallback()
						end
					end, { "i", "s" }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if can_jump_forward() then
							luasnip.jump(1)
						elseif cmp.visible() then
							if not user_interacted then
								cmp.confirm({
									select = true,
									behavior = cmp.ConfirmBehavior.Insert,
								})
							else
								cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
							end
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if can_jump_backward() then
							luasnip.jump(-1)
						elseif cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "luasnip", priority = 1000 },
					{ name = "nvim_lsp", priority = 999 },
					{
						name = "buffer",
						priority = 500,
						option = {

							get_bufnrs = function()
								local bufs = {}
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									bufs[vim.api.nvim_win_get_buf(win)] = true
								end
								return vim.tbl_keys(bufs)
							end,
							max_indexed_line_length = 200,
							indexing_interval = 100,
							max_indexed_lines = 2000,
						},
					},
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
