return {
	"stevearc/resession.nvim",
	config = function()
		-- capture real layout/buffers/cwd (no terminals)
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

		local rs = require("resession")
		rs.setup({
			autosave = { enabled = true, notify = false },
			dir = "sessions",
			branch = true,
		})

		-- Turn CWD into a readable session name like "Users/lukascampbell/.config/nvim"
		local function session_name_from_cwd()
			local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p") -- absolute, normalized
			-- Windows: turn "C:\path\to\proj" -> "C/path/to/proj"
			if cwd:match("^%a:[/\\]") then
				local drive = cwd:sub(1, 1)
				cwd = drive .. cwd:sub(3):gsub("\\", "/")
			end
			-- Strip leading slash on Unix ("/Users/...")->"Users/..."
			cwd = cwd:gsub("^/+", "")
			-- Remove trailing slash
			cwd = cwd:gsub("/+$", "")
			return cwd
		end

		-- Convenience wrappers that always use our cwd-based name
		local function save_current(opts)
			rs.save(session_name_from_cwd(), vim.tbl_extend("force", { dir = "dirsession" }, opts or {}))
		end
		local function load_current(opts)
			return rs.load(session_name_from_cwd(), vim.tbl_extend("force", { dir = "dirsession" }, opts or {}))
		end
		local function delete_current(opts)
			rs.delete(session_name_from_cwd(), vim.tbl_extend("force", { dir = "dirsession" }, opts or {}))
		end

		-- Keymaps: save/load/delete session for THIS cwd under the cwd-based name
		vim.keymap.set("n", "<leader>ss", function()
			save_current({ notify = true })
		end, { desc = "Resession: Save (cwd-named)" })
		vim.keymap.set("n", "<leader>sl", function()
			load_current({ silence_errors = false })
		end, { desc = "Resession: Load (cwd-named)" })
		vim.keymap.set("n", "<leader>sd", function()
			delete_current({})
		end, { desc = "Resession: Delete (cwd-named)" })

		-- On startup: create (first visit) and load/attach the cwd-named session
		vim.api.nvim_create_autocmd("VimEnter", {
			group = vim.api.nvim_create_augroup("ResessionAuto", { clear = true }),
			callback = function()
				vim.defer_fn(function()
					local name = session_name_from_cwd()

					-- Try load; if it doesn't exist yet, create it, then load so autosave attaches
					local ok = rs.load(name, { dir = "dirsession", silence_errors = true })
					if not ok then
						rs.save(name, { dir = "dirsession", notify = false })
						rs.load(name, { dir = "dirsession", silence_errors = true })
					end
				end, 80)
			end,
		})
	end,
}
