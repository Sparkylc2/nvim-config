return {
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			local sig = require("lsp_signature")

			local inline_cfg = {
				bind = true,
				handler_opts = { border = "rounded" },
				floating_window = false,
				hint_enable = true,
				hint_inline = function()
					return true
				end,
				doc_lines = 0,
				zindex = 50,
			}

			local docs_cfg = vim.tbl_deep_extend("force", inline_cfg, {
				floating_window = true,
				doc_lines = 10,
			})

			sig.setup(inline_cfg)

			vim.g.signature_show_docs = false
			vim.keymap.set({ "i", "n" }, "<M-s>", function()
				vim.g.signature_show_docs = not vim.g.signature_show_docs
				if vim.g.signature_show_docs then
					sig.setup(docs_cfg)
					pcall(vim.lsp.buf.signature_help)
				else
					sig.setup(inline_cfg)
					pcall(sig.close)
				end
			end, { desc = "Toggle signature descriptions (inline-only ↔ docs+window)" })

			vim.keymap.set("n", "<leader>is", function()
				pcall(sig.toggle_float_win)
			end, { desc = "Toggle signature help window" })
		end,
	},
}
