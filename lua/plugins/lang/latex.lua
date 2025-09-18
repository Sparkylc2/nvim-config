

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
			vim.g.vimtex_bibliography_autoload = {
				filenames = { "**/bibliography/*.bib" },
			}
		end,
		keys = {
			{ "<leader>lc", "<cmd>VimtexCompile<cr>", desc = "Compile LaTeX" },
			{ "<leader>lv", "<cmd>VimtexView<cr>", desc = "View PDF" },
			{ "<leader>lt", "<cmd>VimtexTocToggle<cr>", desc = "Toggle TOC" },
			{ "<leader>ll", "<cmd>VimtexCompileSS<cr>", desc = "Start continuous compilation" },
			{ "<leader>ls", "<cmd>VimtexStop<cr>", desc = "Stop compilation" },
			{ "<leader>le", "<cmd>VimtexErrors<cr>", desc = "Show errors" },
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
		end,
	},
}
