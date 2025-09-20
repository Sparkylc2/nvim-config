return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "kanagawa",
					component_separators = "|",
					section_separators = "",
					globalstatus = true,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
				},
			})

			local function refresh_lualine()
				vim.schedule(function()
					pcall(function()
						require("lualine").refresh({
							place = { "statusline", "tabline", "winbar" },
						})
					end)
					vim.cmd("redraw!")
					vim.cmd("mode")
				end)
			end

			local resize_group = vim.api.nvim_create_augroup("LualineResizeFix", { clear = true })

			vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "WinNew", "WinClosed" }, {
				group = resize_group,
				callback = function()
					refresh_lualine()
				end,
			})

			vim.api.nvim_create_autocmd({ "FocusGained", "FocusLost" }, {
				group = resize_group,
				callback = function()
					vim.defer_fn(refresh_lualine, 50)
				end,
			})

			vim.api.nvim_create_autocmd("TermResponse", {
				group = resize_group,
				callback = function()
					vim.defer_fn(refresh_lualine, 100)
				end,
			})

			vim.api.nvim_create_user_command("LualineRefresh", function()
				refresh_lualine()
			end, { desc = "Manually refresh lualine" })
		end,
	},
}
