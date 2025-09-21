return {
	{
		"lervag/vimtex",
		ft = "tex",
		event = "VeryLazy",
		init = function()
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
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
			vim.g.vimtex_mappings_disable = {
				n = { "tsD", "tsb", "tsf", "tsc", "ts$", "tss", "tsd", "tse" },
				x = { "tsD", "tsf", "tsd" },
			}
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
		keys = {
			{ "<leader>lc", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX" },
			{ "<leader>lv", "<cmd>VimtexView<cr>", desc = "View PDF" },
			{ "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "Toggle TOC" },
			{ "<leader>ll", "<cmd>VimtexCompileSS<cr>", desc = "Start continuous compilation" },
			{ "<leader>ls", "<cmd>VimtexStop<cr>", desc = "Stop compilation" },
			{ "<leader>le", "<cmd>VimtexErrors<cr>", desc = "Show errors" },
			{ "[[", "<plug>(vimtex-[[)", desc = "Previous section start", ft = "tex", mode = { "n", "x", "o" } },
			{ "[]", "<plug>(vimtex-[])", desc = "Previous section end", ft = "tex", mode = { "n", "x", "o" } },
			{ "][", "<plug>(vimtex-][)", desc = "Next section end", ft = "tex", mode = { "n", "x", "o" } },
			{ "]]", "<plug>(vimtex-]])", desc = "Next section start", ft = "tex", mode = { "n", "x", "o" } },
			{ "[m", "<plug>(vimtex-[m)", desc = "Previous environment start", ft = "tex", mode = { "n", "x", "o" } },
			{ "[M", "<plug>(vimtex-[M)", desc = "Previous environment end", ft = "tex", mode = { "n", "x", "o" } },
			{ "]m", "<plug>(vimtex-]m)", desc = "Next environment start", ft = "tex", mode = { "n", "x", "o" } },
			{ "]M", "<plug>(vimtex-]M)", desc = "Next environment end", ft = "tex", mode = { "n", "x", "o" } },
			{ "[n", "<plug>(vimtex-[n)", desc = "Previous math start", ft = "tex", mode = { "n", "x", "o" } },
			{ "[N", "<plug>(vimtex-[N)", desc = "Previous math end", ft = "tex", mode = { "n", "x", "o" } },
			{ "]n", "<plug>(vimtex-]n)", desc = "Next math start", ft = "tex", mode = { "n", "x", "o" } },
			{ "]N", "<plug>(vimtex-]N)", desc = "Next math end", ft = "tex", mode = { "n", "x", "o" } },
			{ "[r", "<plug>(vimtex-[r)", desc = "Previous frame start", ft = "tex", mode = { "n", "x", "o" } },
			{ "[R", "<plug>(vimtex-[R)", desc = "Previous frame end", ft = "tex", mode = { "n", "x", "o" } },
			{ "]r", "<plug>(vimtex-]r)", desc = "Next frame start", ft = "tex", mode = { "n", "x", "o" } },
			{ "]R", "<plug>(vimtex-]R)", desc = "Next frame end", ft = "tex", mode = { "n", "x", "o" } },
			{ "[*", "<plug>(vimtex-[*)", desc = "Previous comment start", ft = "tex", mode = { "n", "x", "o" } },
			{ "]*", "<plug>(vimtex-]*)", desc = "Next comment start", ft = "tex", mode = { "n", "x", "o" } },
			{ "%", "<plug>(vimtex-%)", desc = "Matching delimiter", ft = "tex", mode = { "n", "x", "o" } },

			{ "uc", "<plug>(vimtex-ic)", desc = "Inner command", ft = "tex", mode = { "x", "o" } },
			{ "ac", "<plug>(vimtex-ac)", desc = "Around command", ft = "tex", mode = { "x", "o" } },
			{ "ud", "<plug>(vimtex-id)", desc = "Inner delimiter", ft = "tex", mode = { "x", "o" } },
			{ "ad", "<plug>(vimtex-ad)", desc = "Around delimiter", ft = "tex", mode = { "x", "o" } },
			{ "ue", "<plug>(vimtex-ie)", desc = "Inner environment", ft = "tex", mode = { "x", "o" } },
			{ "ae", "<plug>(vimtex-ae)", desc = "Around environment", ft = "tex", mode = { "x", "o" } },
			{ "u$", "<plug>(vimtex-i$)", desc = "Inner math", ft = "tex", mode = { "x", "o" } },
			{ "a$", "<plug>(vimtex-a$)", desc = "Around math", ft = "tex", mode = { "x", "o" } },
			{ "uP", "<plug>(vimtex-iP)", desc = "Inner section", ft = "tex", mode = { "x", "o" } },
			{ "aP", "<plug>(vimtex-aP)", desc = "Around section", ft = "tex", mode = { "x", "o" } },
			{ "um", "<plug>(vimtex-im)", desc = "Inner item", ft = "tex", mode = { "x", "o" } },
			{ "am", "<plug>(vimtex-am)", desc = "Around item", ft = "tex", mode = { "x", "o" } },

			{ "dsc", "<plug>(vimtex-cmd-delete)", desc = "Delete surrounding command", ft = "tex" },
			{ "dse", "<plug>(vimtex-env-delete)", desc = "Delete surrounding environment", ft = "tex" },
			{ "ds$", "<plug>(vimtex-env-delete-math)", desc = "Delete surrounding math", ft = "tex" },
			{ "dsd", "<plug>(vimtex-delim-delete)", desc = "Delete surrounding delimiter", ft = "tex" },
			{ "csc", "<plug>(vimtex-cmd-change)", desc = "Change surrounding command", ft = "tex" },
			{ "cse", "<plug>(vimtex-env-change)", desc = "Change surrounding environment", ft = "tex" },
			{ "cs$", "<plug>(vimtex-env-change-math)", desc = "Change surrounding math", ft = "tex" },
			{ "csd", "<plug>(vimtex-delim-change-math)", desc = "Change surrounding delimiter", ft = "tex" },
			{ "tse", "<plug>(vimtex-env-toggle-star)", desc = "Toggle environment star", ft = "tex" },
			{ "tsc", "<plug>(vimtex-cmd-toggle-star)", desc = "Toggle command star", ft = "tex" },
			{ "tss", "<plug>(vimtex-env-toggle-star)", desc = "Toggle star", ft = "tex" },
			{ "ts$", "<plug>(vimtex-env-toggle-math)", desc = "Toggle math environment", ft = "tex" },
			{
				"tsd",
				"<plug>(vimtex-delim-toggle-modifier)",
				desc = "Toggle delimiter modifier",
				ft = "tex",
				mode = { "n", "x" },
			},
			{
				"tsD",
				"<plug>(vimtex-delim-toggle-modifier-reverse)",
				desc = "Toggle delimiter modifier reverse",
				ft = "tex",
				mode = { "n", "x" },
			},
			{ "tsf", "<plug>(vimtex-cmd-toggle-frac)", desc = "Toggle fraction", ft = "tex", mode = { "n", "x" } },
			{ "tsb", "<plug>(vimtex-toggle-star)", desc = "Toggle line break", ft = "tex" },

			{ "]]", "<plug>(vimtex-delim-close)", desc = "Close environment/delimiter", ft = "tex", mode = "i" },
			{ "<F7>", "<plug>(vimtex-cmd-create)", desc = "Create command", ft = "tex", mode = "i" },
			{ "<F8>", "<plug>(vimtex-delim-add-modifiers)", desc = "Add delimiter modifiers", ft = "tex" },
		},
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
					-- VimTeX built-in option to exclude LaTeX commands from spell checking
					vim.g.vimtex_syntax_nospell_comments = 0 -- spell check comments
					-- Ensure spell highlighting is visible
					vim.cmd("highlight SpellBad cterm=underline ctermfg=red gui=underline guifg=red")
					vim.cmd("highlight SpellCap cterm=underline ctermfg=blue gui=underline guifg=blue")
					vim.cmd("highlight SpellLocal cterm=underline ctermfg=cyan gui=underline guifg=cyan")
					vim.cmd("highlight SpellRare cterm=underline ctermfg=magenta gui=underline guifg=magenta")
				end,
			})

			-- vim.api.nvim_create_autocmd("User", {
			-- 	pattern = "VimtexEventInitPost",
			-- 	callback = function(ev)
			-- 		local del = function(mode, lhs)
			-- 			pcall(vim.keymap.del, mode, lhs, { buffer = ev.buf })
			-- 		end
			-- 		for _, lhs in ipairs({ "tsD", "tsb", "tsf", "tsc", "ts$", "tss", "tsd", "tse" }) do
			-- 			del("n", lhs)
			-- 		end
			-- 		for _, lhs in ipairs({ "tsD", "tsf", "tsd" }) do
			-- 			del("x", lhs)
			-- 		end
			-- 	end,
			-- })
		end,
	},
}
