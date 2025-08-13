return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"regex",
					"scss",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"yaml",
					"matlab",
				},
				highlight = {
					enable = true,
					disable = { "latex" },
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
					disable = { "vue" },
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})

			-- 	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			-- 		pattern = "*.vue",
			-- 		callback = function()
			-- 			if vim.bo.filetype ~= "vue" then
			-- 				vim.bo.filetype = "vue"
			-- 			end
			--
			-- 			vim.schedule(function()
			-- 				local ok = pcall(vim.treesitter.start)
			-- 				if not ok then
			-- 					vim.treesitter.stop()
			-- 					vim.treesitter.start()
			-- 				end
			--
			-- 				local parser = vim.treesitter.get_parser(0, "vue")
			-- 				if parser then
			-- 					parser:parse()
			-- 					vim.cmd("redraw!")
			-- 				end
			-- 			end)
			-- 		end,
			-- 	})
			--
			-- 	vim.api.nvim_create_user_command("VueRefresh", function()
			-- 		vim.treesitter.stop()
			-- 		vim.bo.filetype = "vue"
			-- 		vim.treesitter.start()
			-- 		local parser = vim.treesitter.get_parser(0, "vue")
			-- 		if parser then
			-- 			parser:parse()
			-- 		end
			-- 		vim.cmd("redraw!")
			-- 		print("Vue highlighting refreshed")
			-- 	end, { desc = "Refresh Vue treesitter highlighting" })
		end,
	},
}
