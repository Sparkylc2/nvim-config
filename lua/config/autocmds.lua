local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Remove whitespace on save
augroup("RemoveWhitespace", { clear = true })
autocmd("BufWritePre", {
	group = "RemoveWhitespace",
	pattern = "*",
	callback = function()
		if vim.bo.buftype ~= "terminal" then
			vim.cmd([[%s/\s\+$//e]])
		end
	end,
})

-- Language specific settings
augroup("FileTypeSettings", { clear = true })

-- JavaScript/TypeScript
autocmd("FileType", {
	group = "FileTypeSettings",
	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
	end,
})

-- Python
autocmd("FileType", {

	group = "FileTypeSettings",
	pattern = "python",
	callback = function()
		vim.opt_local.colorcolumn = "88"
	end,
})

-- C/C++
autocmd("FileType", {
	group = "FileTypeSettings",
	pattern = { "c", "cpp" },
	callback = function()
		vim.opt_local.commentstring = "// %s"
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})

-- Markdown
autocmd("FileType", {
	group = "FileTypeSettings",
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
	group = "FileTypeSettings",
	pattern = {
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"startuptime",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.buflisted = false
		vim.opt_local.modifiable = false
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "SessionLoadPost",
			nested = true,
			callback = function()
				vim.schedule(function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						if vim.api.nvim_buf_is_loaded(buf) then
							vim.api.nvim_buf_call(buf, function()
								vim.cmd("silent! filetype detect")
								vim.cmd("silent! doautocmd <nomodeline> FileType")
								pcall(vim.cmd, "silent! TSEnable highlight")
							end)
						end
					end
				end)
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		pcall(vim.keymap.del, "n", "<S-k>", { buffer = args.buf })
		pcall(vim.keymap.del, "n", "<C-l>", { buffer = args.buf })

		vim.keymap.set("n", "<S-k>", "<C-w>h", { buffer = args.buf, desc = "Move to left split" })
		vim.keymap.set("n", "<A-k>", ":bprevious<CR>", { buffer = args.buf, desc = "Previous buffer" })
		vim.keymap.set("i", "<C-l>", "<Up>")
	end,
})

-- open pdfs using skim
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = "*.pdf",
	callback = function()
		local pdf_path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "open", "-a", "Skim", pdf_path }, { detach = true })
		vim.cmd("bd!")
	end,
})
-- prevent quitting lone pdf from quitting neovim
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.pdf",
	callback = function()
		vim.bo.bufhidden = "wipe"

		vim.keymap.set("n", "q", function()
			local win_count = #vim.api.nvim_list_wins()
			local buf_count = #vim.api.nvim_list_bufs()

			if win_count == 1 then
				vim.cmd("enew")
				vim.cmd("bd#")
			else
				vim.cmd("bd")
			end
		end, { buffer = true, desc = "Close PDF buffer safely" })
	end,
})

-- view images in preview
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
	callback = function()
		local img_path = vim.fn.expand("%:p")
		vim.fn.jobstart({ "open", img_path }, { detach = true })
		vim.cmd("bd!")
	end,
})

-- treesitter redetect and reapply highlighting after session load
vim.api.nvim_create_autocmd("SessionLoadPost", {
	callback = function()
		vim.schedule(function()
			vim.cmd("silent! filetype plugin indent on")
			vim.cmd("silent! syntax enable")
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					vim.api.nvim_buf_call(buf, function()
						vim.cmd("silent! filetype detect")
						vim.cmd("silent! doautocmd <nomodeline> FileType")
						pcall(vim.treesitter.start, buf)
					end)
				end
			end
		end)
	end,
})

-- stop terminal job when quitting
vim.api.nvim_create_autocmd("CmdlineLeave", {
	callback = function()
		local cmd = vim.fn.getcmdline()
		if cmd == "wqa" or cmd == "wqa!" or cmd == "qa" then
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					local chan = vim.bo[buf].channel
					if chan > 0 then
						vim.fn.jobstop(chan)
					end
				end
			end
		end
	end,
})
