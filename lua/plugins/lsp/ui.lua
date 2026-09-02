return {
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",

		config = function()
			local sig = require("lsp_signature")

			local cfg = {
				bind = true,
				handler_opts = { border = "rounded" },
				floating_window = false,
				hint_enable = true,
				hint_inline = function()
					return vim.api.nvim_get_mode().mode ~= "i"
				end,
				hint_prefix = "",
				hint_scheme = "String",
				max_height = 12,
				max_width = 80,
				doc_lines = 0,
				zindex = 50,
				always_trigger = false,
				auto_close_after = 3,
			}

			sig.setup(cfg)

			local hint_state = 0

			vim.keymap.set({ "i", "n" }, "<M-s>", function()
				hint_state = (hint_state + 1) % 3

				if hint_state == 0 then
					sig.setup(vim.tbl_deep_extend("force", cfg, {
						hint_enable = false,
						floating_window = false,
					}))
					pcall(sig.close)
				elseif hint_state == 1 then
					sig.setup(vim.tbl_deep_extend("force", cfg, {
						hint_enable = true,
						floating_window = false,
						doc_lines = 0,
					}))
				else
					sig.setup(vim.tbl_deep_extend("force", cfg, {
						hint_enable = true,
						floating_window = true,
						doc_lines = 10,
					}))
					pcall(vim.lsp.buf.signature_help)
				end
			end, { desc = "Cycle signature help: off → inline → floating" })

			vim.keymap.set("n", "<leader>is", function()
				pcall(sig.toggle_float_win)
			end, { desc = "Toggle signature help window" })
		end,
	},
}
