return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		enabled = false,
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					-- diagnostics = "nvim_lsp",
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							text_align = "center",
							separator = true,
						},
					},
					numbers = "ordinal",
					separator_style = "slant",
					always_show_bufferline = true,
					show_buffer_close_icons = true,
				},
			})
		end,
	},
}
