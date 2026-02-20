local function start_neovim_server()
	local socket = "/tmp/nvim-arview.sock"

	if vim.fn.filereadable(socket) == 1 then
		vim.fn.delete(socket)
	end

	vim.fn.serverstart(socket)
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = start_neovim_server,
	once = true,
})

if vim.v.vim_did_enter == 1 then
	start_neovim_server()
end

local function sync_to_pdf()
	local line = vim.fn.line(".")
	local file = vim.fn.expand("%:p")

	if not file:match("%.tex$") then
		vim.notify("Not a TeX file", vim.log.levels.WARN)
		return
	end

	local socket_path = "/tmp/nvim-arview-forward.sock"

	if vim.fn.filereadable(socket_path) == 0 then
		vim.notify("arview forward search server not running", vim.log.levels.ERROR)
		return
	end

	local message = vim.fn.json_encode({
		type = "forward-search",
		sourcePath = file,
		line = line,
	})

	local cmd = string.format("echo %s | nc -U %s", vim.fn.shellescape(message), vim.fn.shellescape(socket_path))

	vim.fn.system(cmd)

	vim.notify(string.format("Synced line %d to PDF", line), vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("SyncPDF", sync_to_pdf, {
	desc = "Sync current line to PDF (forward search)",
})

vim.keymap.set("n", "<leader>sp", sync_to_pdf, {
	desc = "Sync to PDF",
	silent = true,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.tex",
	callback = function()
		-- sync_to_pdf()
	end,
})
return {
	{
		"lervag/vimtex",
		ft = "tex",
		event = "VeryLazy",
		init = function()
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
			local function has_tex_root_directive(buf)
				local line_count = vim.api.nvim_buf_line_count(buf)
				local last = math.min(5, line_count)
				local lines = vim.api.nvim_buf_get_lines(buf, 0, last, false)
				for _, l in ipairs(lines) do
					if l:match("%%%s*!%s*[Tt][Ee][Xx].-[Rr][Oo][Oo][Tt]") then
						return true
					end
				end
				return false
			end
			local function find_closest_main_tex(start_path)
				local dir = vim.fs.dirname(start_path)
				local found = vim.fs.find({ "main.tex", "Main.tex" }, { upward = true, path = dir })
				if found and #found > 0 then
					return found[1]
				end
				local here = vim.fs.find({ "main.tex", "Main.tex" }, { upward = false, path = dir })
				if here and #here > 0 then
					return here[1]
				end
				return nil
			end
			vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
				pattern = "*.tex",
				callback = function(args)
					local buf = args.buf
					local name = vim.api.nvim_buf_get_name(buf)
					if name == "" then
						return
					end
					if has_tex_root_directive(buf) then
						return
					end
					local main = find_closest_main_tex(name)
					if main then
						vim.b[buf].vimtex_main = main
					end
				end,
			})
		end,
		config = function()
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.tex",
				callback = function() end,
			})

			function ToggleVimtexQuickfixMode()
				if vim.g.vimtex_quickfix_mode == 1 then
					vim.g.vimtex_quickfix_mode = 0
					print("vimtex_quickfix_mode: 0 (default menu shown)")
				else
					vim.g.vimtex_quickfix_mode = 1
					print("vimtex_quickfix_mode: 1 (default menu hidden)")
				end
			end

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

					vim.keymap.set("x", "p", "p", { buffer = true, desc = "Paste without yanking (TeX)" })
					vim.keymap.set(
						"n",
						"<leader>ss",
						ShowSpellSuggestions,
						{ buffer = true, desc = "Show spell suggestions in float" }
					)
					vim.keymap.set(
						"n",
						"<leader>vq",
						ToggleVimtexQuickfixMode,
						{ buffer = true, desc = "Toggle vimtex_quickfix_mode" }
					)
					vim.keymap.set("n", "<leader>m", function()
						local current = vim.wo.conceallevel
						vim.wo.conceallevel = current == 0 and 2 or 0
					end, { buffer = true, desc = "Toggle conceallevel" })
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = "*.tex",
				callback = function()
					if vim.fn.exists(":VimtexCompile") == 2 then
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
