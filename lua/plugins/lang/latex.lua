return {
	{
		"lervag/vimtex",
		ft = "tex",
		init = function()
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
			vim.g.vimtex_compiler_latexmk = {
				options = {
					"-pdf",
					"-interaction=nonstopmode",
					"-synctex=1",
				},
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
	},
}
