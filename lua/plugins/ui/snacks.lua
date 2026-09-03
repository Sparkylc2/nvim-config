local header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⡆⠀⢀⡀⣀⢀⡀⠀⠀⣀⢀⡀⣀⠀⢠⣿⣿⠏⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠯⠥⠤⢤⣉⣉⡉⠉⠉⠉⢩⣿⣿⣿⣾⠁⠀⠘⠿⣿⣷⣿⡇⠈⢀⣠⣽⣯⡸⣿⣿⣭⣳⠀⣀⣠⡤⠭⠟⠛⠛⠃⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣀⣤⡤⠴⣶⠶⣶⠶⠟⢛⣒⠿⠿⠿⠿⠿⠿⢿⣏⠙⠒⠒⠒⠒⠒⢹⡿⢛⣉⡄⠀⠀⠀⠀⢾⣿⣿⣷⡆⠀⠈⠏⣿⣿⣿⣿⡛⠟⡿⠿⠿⠿⠿⠿⣿⣿⣯⠀⠉⠉⡟⣽⢿⣿⠷⣾⣶⣶⣤⡤⣄⠀
⣯⣆⣤⣤⣴⠦⢤⣤⣤⣄⣉⠁⠈⠉⠉⠉⠒⠉⠁⠀⠀⠀⠀⢐⣀⢼⡿⢭⡇⠀⠀⣀⣠⣴⡿⢇⢈⣿⣿⣦⣄⣐⣤⣹⣿⣿⣿⣤⣿⡀⣀⡀⠀⠀⢀⣀⣀⣠⣤⣤⠤⢤⣴⣶⣿⣿⡿⠿⠿⠿⠛⠂
⠀⠀⠈⠋⠉⠙⠓⠒⠒⠒⠒⠛⠿⠷⠴⠤⠤⠤⠆⠠⠤⣄⣶⣤⡤⠌⠐⠋⠀⠐⠁⢸⣾⣿⣿⡿⢺⣿⣿⣿⣿⣧⣭⣛⣯⣽⣿⡷⣾⠿⠿⠿⠯⠭⠿⠗⠒⠚⠛⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢇⡇⠀⡤⠚⠁⢰⣾⣿⣼⣾⣇⢸⣿⣿⣿⣿⣿⣯⡏⢿⣿⠻⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⢴⣦⣤⣤⣭⣧⡟⡟⠻⡿⡟⢻⣿⣿⣿⣿⣿⣿⣯⣭⣭⣭⡿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣧⢀⠀⠀⠀⠀⠉⢹⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣮⠀⣢⠔⠊⡑⢸⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⣁⣤⡘⢇⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠷⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]]

return {
	{

		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- turns off treesitter/LSP/syntax on huge files
			bigfile = {
				enabled = true,
			},

			-- replaces alpha-nvim
			dashboard = {
				enabled = true,
				preset = {
					header = header,
					keys = {
						{ icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
						{ icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
						{ icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
						{ icon = " ", key = "t", desc = "Find text", action = ":lua Snacks.picker.grep()" },
						{ icon = " ", key = "s", desc = "Restore session", action = ":AutoSession restore" },
						{
							icon = " ",
							key = "c",
							desc = "Configuration",
							action = ":e ~/.config/nvim/init.lua",
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ text = "Flight dynamics will be the death of me", hl = "Type", align = "center" },
				},
			},

			-- replaces peepsight
			dim = { enabled = true },

			-- replaces indent-blankline
			indent = {
				enabled = true,
				indent = { char = "│" },
				scope = { enabled = false },
			},

			input = { enabled = true },

			-- replaces kdheepak/lazygit.nvim
			lazygit = { enabled = true },

			-- no dimming behind any snacks float
			styles = {
				lazygit = { backdrop = false },
				terminal = { backdrop = false },
				float = { backdrop = false },
				notification = { backdrop = false },
			},

			notifier = { enabled = true, timeout = 3000 },

			image = {
				enabled = true,
				doc = {
					enabled = true,
					inline = true,
					float = true,
					-- max_width = 100,
					-- max_height = 30,
				},
				math = {
					enabled = true,
					latex = {
						font_size = "large",
						packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
					},
				},
			},

			-- LSP-aware file rename
			rename = { enabled = true },

			scratch = { enabled = true },

			scroll = {
				enabled = true,
				animate = {
					duration = { step = 5, total = 30 },
					-- easing = "inOutSine",
					easing = "linear",
				},
				animate_repeat = {
					delay = 20,
					duration = { step = 3, total = 25 },
					easing = "linear",
				},
			},

			-- ]] / [[ jump between LSP references of the symbol under the cursor
			words = { enabled = true },
		},

		keys = {
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "LazyGit",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "LazyGit log",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Scratch buffer",
			},
			{
				"<leader>,",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select scratch buffer",
			},
			{
				"]]",
				function()
					Snacks.words.jump(1)
				end,
				desc = "Next reference",
			},
			{
				"[[",
				function()
					Snacks.words.jump(-1)
				end,
				desc = "Prev reference",
			},
		},

		init = function()
			local INLINE_FONT_SIZE = "Large"

			local function patch_inline_math_size()
				local ok, doc = pcall(require, "snacks.image.doc")
				if not ok or type(doc) ~= "table" or type(doc.transforms) ~= "table" then
					return
				end
				local orig = doc.transforms.latex
				if type(orig) ~= "function" then
					return
				end
				doc.transforms.latex = function(img, ctx)
					local raw = vim.trim(img.content or "")
					orig(img, ctx)
					local inline = raw:match("^%$[^$]") or raw:match("^\\%(")
					if not inline or not img.content then
						return
					end
					local size = (Snacks.image.config.math.latex or {}).font_size or "large"
					local from = "\\" .. size .. " \\selectfont"
					img.content = img.content:gsub(vim.pesc(from), "\\" .. INLINE_FONT_SIZE .. " \\selectfont", 1)
				end
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "quarto", "tex", "latex" },
				once = true,
				callback = patch_inline_math_size,
			})

			local function math_hl()
				vim.api.nvim_set_hl(0, "SnacksImageMath", { fg = "#FFFFFF" })
			end
			math_hl()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = math_hl })

			vim.api.nvim_create_autocmd("User", {
				pattern = "OilActionsPost",
				callback = function(event)
					if event.data and event.data.actions then
						for _, a in ipairs(event.data.actions) do
							if a.type == "move" then
								Snacks.rename.on_rename_file(a.src_url, a.dest_url)
							end
						end
					end
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- replaces the hand-rolled inlay-hints toggle in lsp/ui.lua
					Snacks.toggle.dim():map("<leader>p")
					Snacks.toggle.inlay_hints():map("<leader>ih")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle({
						name = "Spelling & grammar",
						get = function()
							return vim.wo.spell
						end,
						set = function(state)
							vim.wo.spell = state
							for _, client in ipairs(vim.lsp.get_clients({ name = "ltex" })) do
								local ns = vim.lsp.diagnostic.get_namespace(client.id, false)
								vim.diagnostic.enable(state, { ns_id = ns, bufnr = 0 })
							end
						end,
					}):map("<leader>us")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle.treesitter():map("<leader>uT")
				end,
			})
		end,
	},
}
