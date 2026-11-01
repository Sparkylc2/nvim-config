-- Resolve the main .tex file for a buffer and hand it to VimTeX via b:vimtex_main.
--
-- VimTeX's own recursive search only sees \input at the start of a line, so a
-- section included as `\block{..}{\input{sections/x}}` is missed and the
-- compile fails with "failed mainfile detection". This walks up the tree,
-- finds every real main file (\documentclass + \begin{document}) and picks the
-- one whose include graph reaches the current file, wherever the \input sits.

local M = {}

local MAX_LEVELS = 6
local MAX_DEPTH = 20

local uv = vim.uv
local cache = {}

local function realpath(path)
	return uv.fs_realpath(path) or vim.fs.normalize(path)
end

local function read(path)
	local stat = uv.fs_stat(path)
	if not stat or stat.type ~= "file" then
		return nil
	end
	local hit = cache[path]
	if hit and hit.mtime == stat.mtime.sec and hit.size == stat.size then
		return hit.lines
	end
	local ok, lines = pcall(vim.fn.readfile, path)
	if not ok then
		return nil
	end
	cache[path] = { mtime = stat.mtime.sec, size = stat.size, lines = lines }
	return lines
end

local function strip_comment(line)
	local i = 1
	while true do
		local p = line:find("%", i, true)
		if not p then
			return line
		end
		if p == 1 or line:sub(p - 1, p - 1) ~= "\\" then
			return line:sub(1, p - 1)
		end
		i = p + 1
	end
end

-- same rule as VimTeX: `%! TeX root = ...` in the first five lines
local function has_texroot(lines)
	for i = 1, math.min(5, #lines) do
		if lines[i]:match("^%s*%%%s*!?%s*[Tt][Ee][Xx]%s+[Rr][Oo][Oo][Tt]%s*=") then
			return true
		end
	end
	return false
end

local function has_class(lines)
	for _, raw in ipairs(lines) do
		if strip_comment(raw):find("\\documentclass") then
			return true
		end
	end
	return false
end

local function is_main(lines)
	local class, body = false, false
	for _, raw in ipairs(lines) do
		local l = strip_comment(raw)
		if not class then
			local name = l:match("\\documentclass%s*%b[]%s*(%b{})") or l:match("\\documentclass%s*(%b{})")
			if name and name ~= "{subfiles}" and name ~= "{standalone}" then
				class = true
			end
		end
		if class and l:find("\\begin%s*{document}") then
			body = true
			break
		end
	end
	return class and body
end

local SINGLE = { "input", "include", "subfile", "subfileinclude", "InputIfFileExists" }
local DOUBLE = { "import", "subimport", "inputfrom", "subinputfrom", "includefrom", "subincludefrom" }

local function refs(lines)
	local out = {}
	for _, raw in ipairs(lines) do
		local l = strip_comment(raw)
		if l:find("\\", 1, true) then
			for _, cmd in ipairs(SINGLE) do
				for arg in l:gmatch("\\" .. cmd .. "%*?%s*(%b{})") do
					out[#out + 1] = arg:sub(2, -2)
				end
			end
			for _, cmd in ipairs(DOUBLE) do
				for dir, file in l:gmatch("\\" .. cmd .. "%*?%s*(%b{})%s*(%b{})") do
					dir = dir:sub(2, -2)
					if dir ~= "" and not dir:match("/$") then
						dir = dir .. "/"
					end
					out[#out + 1] = dir .. file:sub(2, -2)
				end
			end
			-- plain TeX form: \input file
			for arg in l:gmatch("\\input%s+([^%s{}\\]+)") do
				out[#out + 1] = arg
			end
		end
	end
	return out
end

local function resolve(name, dirs)
	name = vim.trim(name):gsub('^"(.*)"$', "%1")
	if name == "" or name:find("\\", 1, true) or name:find("#", 1, true) then
		return nil
	end
	local bases = {}
	if name:sub(1, 1) == "/" then
		bases[1] = name
	else
		for _, d in ipairs(dirs) do
			bases[#bases + 1] = d .. "/" .. name
		end
	end
	for _, base in ipairs(bases) do
		for _, p in ipairs({ base .. ".tex", base }) do
			local stat = uv.fs_stat(p)
			if stat and stat.type == "file" then
				return realpath(p)
			end
		end
	end
	return nil
end

local function reaches(file, target, root, visited, depth)
	local lines = read(file)
	if not lines or depth > MAX_DEPTH then
		return false
	end
	local dirs = { root, vim.fs.dirname(file) }
	for _, ref in ipairs(refs(lines)) do
		local p = resolve(ref, dirs)
		if p == target then
			return true
		end
		if p and not visited[p] and p:match("%.tex$") then
			visited[p] = true
			if reaches(p, target, root, visited, depth + 1) then
				return true
			end
		end
	end
	return false
end

local function mains_in(dir, target)
	local found = {}
	for name, kind in vim.fs.dir(dir) do
		if (kind == "file" or kind == "link") and name:match("%.tex$") then
			local p = realpath(dir .. "/" .. name)
			if p ~= target then
				local lines = read(p)
				if lines and is_main(lines) then
					found[#found + 1] = p
				end
			end
		end
	end
	-- main.tex first, then alphabetical, so the result is stable
	table.sort(found, function(a, b)
		local ma, mb = vim.fs.basename(a):lower() == "main.tex", vim.fs.basename(b):lower() == "main.tex"
		if ma ~= mb then
			return ma
		end
		return a < b
	end)
	return found
end

local function newest(paths)
	local best, best_t = nil, -1
	for _, p in ipairs(paths) do
		local stat = uv.fs_stat(p)
		if stat and stat.mtime.sec > best_t then
			best, best_t = p, stat.mtime.sec
		end
	end
	return best
end

--- Main file for `path`, or nil when VimTeX should decide on its own
--- (the file has its own \documentclass, e.g. a main, standalone or subfiles
--- file, or carries a `%! TeX root` directive).
function M.find(path)
	if not path or path == "" then
		return nil
	end
	local target = realpath(path)
	local lines = read(target)
	if lines and (has_texroot(lines) or has_class(lines)) then
		return nil
	end

	local home = realpath(vim.env.HOME or "~")
	local stop = vim.fs.root(target, ".git")
	stop = stop and realpath(stop) or nil

	local dir = vim.fs.dirname(target)
	local fallback
	for _ = 1, MAX_LEVELS do
		local mains = mains_in(dir, target)
		for _, m in ipairs(mains) do
			if reaches(m, target, dir, { [m] = true }, 0) then
				return m
			end
		end
		-- nothing includes this file (yet): use the nearest project's main
		if not fallback and #mains > 0 then
			local first = mains[1]
			fallback = (vim.fs.basename(first):lower() == "main.tex" or #mains == 1) and first or newest(mains)
		end
		local parent = vim.fs.dirname(dir)
		if dir == stop or dir == home or parent == dir then
			break
		end
		dir = parent
	end
	return fallback
end

function M.setup()
	vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
		group = vim.api.nvim_create_augroup("tex_mainfile", { clear = true }),
		pattern = "*.tex",
		callback = function(args)
			local ok, main = pcall(M.find, vim.api.nvim_buf_get_name(args.buf))
			if not ok then
				vim.notify("texmain: " .. tostring(main), vim.log.levels.WARN)
				return
			end
			vim.b[args.buf].vimtex_main = main
		end,
	})
end

return M
