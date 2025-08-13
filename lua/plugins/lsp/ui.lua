vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		pcall(function()
			vim.lsp.inlay_hint.enable(args.buf, false)
		end)
	end,
})

vim.keymap.set("n", "<leader>ih", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local ok_is_enabled, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
	if not ok_is_enabled then
		is_enabled = false
	end
	pcall(vim.lsp.inlay_hint.enable, bufnr, not is_enabled)
end, { desc = "Toggle Inlay Hints" })

return {
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			local sig = require("lsp_signature")

			-- Base config - less aggressive inline hints
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
				-- Reduce aggressiveness
				always_trigger = false,
				auto_close_after = 3, -- Auto close after 5 seconds
			}

			sig.setup(cfg)

			-- Toggle between no hints, inline hints, and floating window
			local hint_state = 0 -- 0: off, 1: inline, 2: floating

			vim.keymap.set({ "i", "n" }, "<M-s>", function()
				hint_state = (hint_state + 1) % 3

				if hint_state == 0 then
					-- Turn off
					sig.setup(vim.tbl_deep_extend("force", cfg, {
						hint_enable = false,
						floating_window = false,
					}))
					pcall(sig.close)
				elseif hint_state == 1 then
					-- Inline only
					sig.setup(vim.tbl_deep_extend("force", cfg, {
						hint_enable = true,
						floating_window = false,
						doc_lines = 0,
					}))
				else
					-- Floating window
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
