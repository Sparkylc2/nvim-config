-- new markdown file next to the current one. inside a Year 3 class folder it
-- gets a short form of Misc/Templates/Note.md, tagged with the class; anywhere
-- else it's blank.

local M = {}

local year3 = vim.fn.resolve(vim.fn.expand("~/Documents/Year 3"))

-- folder of the current buffer, falling back to cwd for oil/scratch buffers
local function current_dir()
	local name = vim.api.nvim_buf_get_name(0)
	if name:match("^oil://") then
		local ok, oil = pcall(require, "oil")
		local dir = ok and oil.get_current_dir()
		if dir then
			return dir
		end
	end
	if name == "" or vim.bo.buftype ~= "" then
		return vim.fn.getcwd()
	end
	return vim.fs.dirname(name)
end

-- "Advanced Creative Writing" -> "advanced_creative_writing"
local function class_tag(folder)
	return (folder:lower():gsub("[^%w]+", "_"):gsub("^_+", ""):gsub("_+$", ""))
end

-- top-level Year 3 folder that dir sits in, or nil
local function class_of(dir)
	dir = vim.fn.resolve(dir)
	if dir:sub(1, #year3 + 1) ~= year3 .. "/" then
		return nil
	end
	return dir:sub(#year3 + 2):match("^[^/]+")
end

local function note_lines(id, class)
	return {
		"---",
		("id: %q"):format(id),
		"aliases: []",
		"tags:",
		"  - me",
		"kind: note",
		"class: " .. class_tag(class),
		"created: " .. os.date("%Y-%m-%d"),
		"---",
		"",
		"# " .. id,
		"",
		"",
	}
end

function M.create()
	local dir = current_dir()
	vim.ui.input({ prompt = "New note: " }, function(input)
		local name = input and vim.trim(input):gsub("%.md$", "")
		if not name or name == "" then
			return
		end

		local path = vim.fs.joinpath(dir, name .. ".md")
		if vim.uv.fs_stat(path) then
			vim.notify(("%s already exists, opening it"):format(vim.fn.fnamemodify(path, ":~")), vim.log.levels.WARN)
			vim.cmd.edit(vim.fn.fnameescape(path))
			return
		end

		vim.fn.mkdir(vim.fs.dirname(path), "p")
		local class = class_of(dir)
		local lines = class and note_lines(vim.fs.basename(name), class) or {}
		vim.fn.writefile(lines, path)
		vim.cmd.edit(vim.fn.fnameescape(path))
		if #lines > 0 then
			vim.api.nvim_win_set_cursor(0, { #lines, 0 })
		end
	end)
end

return M
