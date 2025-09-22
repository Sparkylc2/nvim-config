return {
	{
		"lervag/vimtex",

		ft = "tex",
		event = "VeryLazy",
		init = function()
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
			vim.g.vimtex_complete_enabled = 1
			vim.g.vimtex_complete_close_braces = 1
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
			vim.g.vimtex_compiler_latexmk = {
				backend = "biber",
				executable = "latexmk",
				continuous = 0,
				options = {
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-shell-escape",
				},
			}
			vim.g.vimtex_bibliography_autoload = { filenames = { "**/bibliography/*.bib" } }

			-- Root detection policy:
			-- 1) If first 5 lines contain a TeX root directive, let VimTeX use it.
			-- 2) Else, set b:vimtex_main to the closest 'main.tex' found upward.
			-- 3) Else, fall back to VimTeX's own detection/scan.
			----------------------------------------------------------------
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
				callback = function()
					if vim.fn.exists(":VimtexCompile") == 2 then
						vim.cmd("silent VimtexCompile")
					end
				end,
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "tex",
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = "en_us"
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
}
