return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local max_buffers = 5
			local recent_bufs = {}

			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function(args)
					local buf = args.buf
					if vim.api.nvim_buf_get_option(buf, "buftype") == "" then
						for i, b in ipairs(recent_bufs) do
							if b == buf then
								table.remove(recent_bufs, i)
								break
							end
						end
						table.insert(recent_bufs, 1, buf)
						while #recent_bufs > max_buffers do
							table.remove(recent_bufs)
						end
					end
				end,
			})

			require("bufferline").setup({
				options = {
					numbers = "ordinal",
					separator_style = "slant",
					always_show_bufferline = true,
					show_buffer_close_icons = true,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							text_align = "center",
							separator = true,
						},
					},
					custom_filter = function(bufnr)
						for _, recent in ipairs(recent_bufs) do
							if bufnr == recent then
								return true
							end
						end
						return false
					end,
				},
			})
		end,
	},
}
