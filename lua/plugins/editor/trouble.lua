return {
	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{
				"<leader>tt",
				function()
					vim.cmd("QF2Diag")
					local t = require("trouble")
					if t.is_open("diagnostics") then
						t.close("diagnostics")
					else
						t.open("diagnostics")
					end
				end,
			},
			{ "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{ "<leader>tS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
			{ "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>tQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
		config = function(opts)
			require("trouble").setup(opts)
			local ns_qf = vim.api.nvim_create_namespace("quickfix_as_diagnostics")

			local function pick_main_buf()
				local cur = vim.api.nvim_get_current_buf()
				local main = vim.b[cur] and vim.b[cur].vimtex_main or nil
				if main and main ~= "" then
					local b = vim.fn.bufadd(main)
					vim.fn.bufload(b)
					return b
				end
				for _, b in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].filetype == "tex" then
						return b
					end
				end
				return cur
			end

			local function quickfix_to_diagnostics()
				local qf = vim.fn.getqflist()
				local fallback_buf = pick_main_buf()

				for _, b in ipairs(vim.api.nvim_list_bufs()) do
					vim.diagnostic.reset(ns_qf, b)
				end

				local per_buf = {}
				for _, it in ipairs(qf) do
					local bufnr = (it.bufnr and it.bufnr > 0) and it.bufnr or nil
					if not bufnr and it.filename and it.filename ~= "" then
						bufnr = vim.fn.bufadd(it.filename)
						vim.fn.bufload(bufnr)
					end
					if not bufnr or bufnr <= 0 then
						bufnr = fallback_buf
					end

					local sev = vim.diagnostic.severity.ERROR
					if it.type == "W" then
						sev = vim.diagnostic.severity.WARN
					elseif it.type == "I" then
						sev = vim.diagnostic.severity.INFO
					elseif it.type == "N" then
						sev = vim.diagnostic.severity.HINT
					end

					per_buf[bufnr] = per_buf[bufnr] or {}
					table.insert(per_buf[bufnr], {
						lnum = math.max((it.lnum or 1) - 1, 0),
						col = math.max((it.col or 1) - 1, 0),
						message = it.text or "",
						severity = sev,
						source = "quickfix",
					})
				end

				for b, diags in pairs(per_buf) do
					vim.diagnostic.set(ns_qf, b, diags, {
						underline = false,
						virtual_text = false,
						signs = true,
						update_in_insert = false,
					})
				end
			end

			vim.api.nvim_create_user_command("QF2Diag", function()
				quickfix_to_diagnostics()

				local ok, trouble = pcall(require, "trouble")
				if ok and trouble.is_open("diagnostics") then
					trouble.refresh("diagnostics")
				end
			end, {})

			vim.api.nvim_create_autocmd("User", {
				pattern = { "VimtexEventCompileSuccess", "VimtexEventCompileFailed" },
				callback = function()
					vim.defer_fn(function()
						quickfix_to_diagnostics()
						local ok, trouble = pcall(require, "trouble")
						if ok and trouble.is_open("diagnostics") then
							trouble.refresh("diagnostics")
						end
					end, 60)
				end,
			})

			vim.api.nvim_create_autocmd("QuickFixCmdPost", {
				callback = function()
					vim.schedule(quickfix_to_diagnostics)
				end,
			})
		end,
	},
}
