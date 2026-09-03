return {
	{
		"jmbuhr/otter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "markdown", "quarto" },
		opts = {
			lsp = {
				diagnostic_update_events = { "BufWritePost", "InsertLeave" },
			},
			buffers = {
				set_filetype = true,
				write_to_disk = false,
			},
			handle_leading_whitespace = true,
		},
		config = function(_, opts)
			require("otter").setup(opts)

			local function fenced_languages(buf)
				local seen, langs = {}, {}
				for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
					local lang = line:match("^%s*```{?%s*([%w_+-]+)")
					if lang then
						lang = lang:lower()
						if lang == "py" then
							lang = "python"
						end
						if not seen[lang] then
							seen[lang] = true
							langs[#langs + 1] = lang
						end
					end
				end
				return langs
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "markdown", "quarto" },
				group = vim.api.nvim_create_augroup("otter_activate", { clear = true }),
				callback = function(ev)
					local langs = fenced_languages(ev.buf)
					if #langs == 0 then
						return
					end
					pcall(require("otter").activate, langs)
				end,
			})
		end,
	},
}
