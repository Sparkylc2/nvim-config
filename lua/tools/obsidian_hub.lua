-- open any markdown file in obsidian. files inside a registered vault open there;
-- anything else gets its folder symlinked into a small hub vault on demand, so
-- obsidian only indexes folders actually used, never all of ~/Documents or OneDrive.

local M = {}

local uv = vim.uv
local home = vim.fn.resolve(vim.fn.expand("~"))
local cloud = home .. "/Library/CloudStorage"

M.hub = home .. "/.obsidian-hub"

local function under(path, root)
	return path:sub(1, #root + 1) == root .. "/"
end

-- registered vault roots, resolved
local function vaults()
	local ok, cfg = pcall(function()
		local f = home .. "/Library/Application Support/obsidian/obsidian.json"
		return vim.json.decode(table.concat(vim.fn.readfile(f), "\n"))
	end)
	local roots = {}
	for _, v in pairs(ok and cfg.vaults or {}) do
		table.insert(roots, vim.fn.resolve(v.path))
	end
	return roots
end

-- too big to hand to obsidian whole
local function too_big(dir)
	return dir == "/"
		or dir == home
		or dir == home .. "/Documents"
		or dir == home .. "/Library"
		or dir == cloud
		or vim.fs.dirname(dir) == cloud
end

-- where a real folder shows up inside the hub: ~/Downloads/x -> Downloads/x,
-- cloud drives by name, anything outside home under _root
local function hub_path(dir)
	if under(dir, cloud) then
		return M.hub .. "/" .. dir:sub(#cloud + 2)
	elseif under(dir, home) then
		return M.hub .. "/" .. dir:sub(#home + 2)
	end
	return M.hub .. "/_root" .. dir
end

local function is_link_to(p, dir)
	local st = uv.fs_lstat(p)
	return st and st.type == "link" and vim.fn.resolve(p) == dir
end

-- true if p holds nothing but symlinks and (possibly nested) empty dirs
local function only_links(p)
	for name, t in vim.fs.dir(p) do
		local c = p .. "/" .. name
		if t == "directory" then
			if not only_links(c) then
				return false
			end
		elseif t ~= "link" and name ~= ".DS_Store" then
			return false
		end
	end
	return true
end

local function remove_links(p)
	for name, t in vim.fs.dir(p) do
		local c = p .. "/" .. name
		if t == "directory" then
			remove_links(c)
		else
			uv.fs_unlink(c)
		end
	end
	uv.fs_rmdir(p)
end

-- hub path of dir, linking it (or reusing a linked ancestor). returns path, created?
local function link(dir)
	local a = dir
	while a ~= "/" and a ~= home do
		local p = hub_path(a)
		if is_link_to(p, a) then
			return p .. dir:sub(#a + 1), false
		end
		a = vim.fs.dirname(a)
	end

	if too_big(dir) then
		return nil, ("%s is too big for the hub, move the file into a subfolder"):format(vim.fn.fnamemodify(dir, ":~"))
	end

	local p = hub_path(dir)
	local st = uv.fs_lstat(p)
	if st then
		-- earlier links to subfolders of dir: replace them with the one link
		if st.type ~= "directory" or not only_links(p) then
			return nil, ("%s already exists in the hub"):format(p:sub(#M.hub + 2))
		end
		remove_links(p)
	end
	vim.fn.mkdir(vim.fs.dirname(p), "p")
	local ok, err = uv.fs_symlink(dir, p)
	if not ok then
		return nil, err
	end
	return p, true
end

local function uri(vault_root, path)
	return ("obsidian://open?vault=%s&file=%s"):format(
		vim.uri_encode(vim.fs.basename(vault_root), "rfc3986"),
		vim.uri_encode(path:sub(#vault_root + 2), "rfc3986")
	)
end

--- obsidian uri for file, or nil + error. `linked` is true when a folder was just
--- added to the hub, so obsidian needs a moment to see it.
---@return string|nil uri, string|boolean|nil err_or_linked
function M.uri(file)
	file = vim.fn.resolve(file)
	local roots = vaults()
	for _, root in ipairs(roots) do
		if under(file, root) then
			return uri(root, file)
		end
	end

	if not vim.tbl_contains(roots, M.hub) then
		vim.fn.mkdir(M.hub, "p")
		return nil,
			"open ~/.obsidian-hub as a vault once (Open folder as vault, ⌘⇧. shows hidden folders), then try again"
	end

	local dir, created = link(vim.fs.dirname(file))
	if not dir then
		return nil, created
	end
	return uri(M.hub, dir .. "/" .. vim.fs.basename(file)), created
end

return M
