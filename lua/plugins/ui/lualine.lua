return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local base = require("lualine.themes.kanagawa")

			local theme = vim.deepcopy(base)
			local function set_center_bg(t, hex)
				for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
					if t[mode] and t[mode].c then
						t[mode].c.bg = hex
					end
				end

				return t
			end
			set_center_bg(theme, "#181616")

			require("lualine").setup({
				options = {
					component_separators = "|",
					section_separators = "",
					globalstatus = true,
					theme = theme,
				},
				sections = {
					lualine_a = {
						{
							"mode",
							fmt = function(s)
								return s:sub(1, 1)
							end,
						},
					},
				},
			})

			vim.api.nvim_create_autocmd("WinResized", {
				callback = function()
					vim.defer_fn(function()
						require("lualine").refresh({ place = { "statusline" }, force = true })
					end, 50)
				end,
			})
		end,
	},
}
