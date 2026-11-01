return {
	{
		"lervag/vimtex",
		ft = "tex",
		event = "VeryLazy",
		init = function()
			vim.g.vimtex_syntax_conceal_disable = 1

			vim.g.vimtex_view_method = "general"
			vim.g.vimtex_view_general_viewer = "arview"
			vim.g.vimtex_view_general_options = ("--ppid %d @pdf"):format(vim.fn.getpid())
			vim.g.vimtex_view_use_temp_files = 0
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_enabled = 1
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_view_automatic = 1
			vim.g.vimtex_compiler_latexmk = {
				backend = "biber",
				executable = "latexmk",
				continuous = 0,
				options = {
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-shell-escape",
					"-view=none",
				},
			}
			vim.g.vimtex_complete_enabled = 1
			vim.g.vimtex_complete_close_braces = 1
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
			vim.g.vimtex_bibliography_autoload = { filenames = { "**/bibliography/*.bib" } }
			require("tools.texmain").setup()
		end,
		config = function()
			function ShowSpellSuggestions()
				local word = vim.fn.expand("<cword>")
				local suggestions = vim.fn.spellsuggest(word, 10)
				if #suggestions == 0 then
					suggestions = { "No suggestions" }
				end
				local buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, suggestions)
				local width = 1
				for _, s in ipairs(suggestions) do
					if #s > width then
						width = #s
					end
				end
				local opts = {
					relative = "cursor",
					row = 1,
					col = 0,
					width = width + 2,
					height = #suggestions,
					style = "minimal",
					border = "rounded",
				}
				local win = vim.api.nvim_open_win(buf, true, opts)
				vim.keymap.set("n", "<Esc>", function()
					vim.api.nvim_win_close(win, true)
				end, { buffer = buf, nowait = true })
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en_gb"
					vim.opt_local.conceallevel = 2
					vim.opt_local.concealcursor = ""

					vim.keymap.set("x", "p", "p", { buffer = true, desc = "Paste without yanking (TeX)" })
					vim.keymap.set(
						"n",
						"<leader>ss",
						ShowSpellSuggestions,
						{ buffer = true, desc = "Show spell suggestions in float" }
					)
					vim.keymap.set("n", "<leader>mm", function()
						local current = vim.wo.conceallevel
						vim.wo.conceallevel = current == 0 and 2 or 0
					end, { buffer = true, desc = "Toggle conceallevel" })
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.tex",
				callback = function()
					-- skip files VimTeX could not place in a project instead of erroring on every save
					if
						vim.fn.exists(":VimtexCompile") == 2
						and vim.fn.eval("exists('b:vimtex') && b:vimtex.is_compileable()") == 1
					then
						vim.cmd("silent VimtexCompile")
					end
				end,
			})

			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = function()
					vim.cmd("highlight SpellBad cterm=underline ctermfg=red gui=underline guifg=#E82424")
					vim.cmd("highlight SpellCap cterm=underline ctermfg=blue gui=underline guifg=#7FB4CA")
					vim.cmd("highlight SpellLocal cterm=underline ctermfg=cyan gui=underline guifg=#7AA89F")
					vim.cmd("highlight SpellRare cterm=underline ctermfg=magenta gui=underline guifg=#938AA9")
				end,
			})
		end,
	},
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	lazy = false,
	-- 	ft = { "tex", "latex" },
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	config = function()
	-- 		require("markview").setup({
	-- 			preview = {
	-- 				filetypes = { "markdown", "tex", "latex" },
	-- 				ignore_buftypes = {},
	-- 			},
	-- 			latex = {
	-- 				enable = true,
	-- 				blocks = {
	-- 					enable = true,
	-- 					hl = "RenderMarkdownMath",
	-- 					text = function(content)
	-- 						local result = vim.fn.system("utftex " .. vim.fn.shellescape(content))
	-- 						return vim.trim(result)
	-- 					end,
	-- 				},
	-- 				inlines = {
	-- 					enable = true,
	-- 					hl = "RenderMarkdownMath",
	-- 				},
	-- 				subscripts = { enable = true },
	-- 				superscripts = { enable = true },
	-- 				symbols = { enable = true },
	-- 				commands = { enable = true },
	-- 			},
	-- 			markdown = {
	-- 				headings = { enable = false },
	-- 			},
	-- 			code_blocks = { enable = false },
	-- 			checkboxes = { enable = false },
	-- 		})
	-- 	end,
	-- },
}
