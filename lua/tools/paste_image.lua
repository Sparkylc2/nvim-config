-- pasting an image file copied in Finder into a Year 3 note copies the file into
-- the vault's attachment folder and inserts ![[name]] instead of the filename.
-- hooks both Cmd+V (vim.paste) and p from the clipboard register.

local M = {}

local year3 = vim.fn.resolve(vim.fn.expand("~/Documents/Year 3"))

-- file paths on the macOS clipboard, one per line
local clipboard_files_js = [[
ObjC.import("AppKit");
var urls = $.NSPasteboard.generalPasteboard.readObjectsForClassesOptions(
	$([$.NSURL]), $({ NSPasteboardURLReadingFileURLsOnlyKey: true }));
var out = [];
for (var i = 0; i < urls.count; i++) out.push(urls.objectAtIndex(i).path.js);
out.join("\n");
]]

local function is_image(name)
	local ext = name:match("%.(%w+)$")
	local formats = Snacks and Snacks.image and Snacks.image.config.formats
		or { "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "heic", "avif", "svg" }
	return ext ~= nil and vim.tbl_contains(formats, ext:lower())
end

-- a Finder copy pastes as the displayed names (often without extension), so
-- only short path-free text is worth the ~50ms clipboard query
local function could_be_filenames(lines)
	local names = vim.split(table.concat(lines, "\n"), "[\r\n]", { trimempty = true })
	if #names == 0 or #names > 50 then
		return false
	end
	for _, name in ipairs(names) do
		if #name > 255 or name:find("/") then
			return false
		end
	end
	return true
end

local function attachment_dir()
	local ok, app = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(year3 .. "/.obsidian/app.json"), "\n"))
	end)
	return vim.fs.joinpath(year3, ok and app.attachmentFolderPath or "")
end

local function same_file(a, b)
	local sa, sb = vim.uv.fs_stat(a), vim.uv.fs_stat(b)
	return sa and sb and sa.size == sb.size and vim.fn.readblob(a) == vim.fn.readblob(b)
end

-- copy src into dir, "name 1.png" style on a clash; returns the name used
local function copy_in(src, dir)
	local base, ext = vim.fs.basename(src):match("^(.-)(%.[^.]+)$")
	local name, n = base .. ext, 0
	while vim.uv.fs_stat(vim.fs.joinpath(dir, name)) do
		if same_file(src, vim.fs.joinpath(dir, name)) then
			return name
		end
		n = n + 1
		name = ("%s %d%s"):format(base, n, ext)
	end
	local ok, err = vim.uv.fs_copyfile(src, vim.fs.joinpath(dir, name))
	if not ok then
		error(err)
	end
	return name
end

-- ![[name]] lines for the image files on the clipboard, or nil to paste normally
local function embeds_from_clipboard()
	local res = vim.system({ "osascript", "-l", "JavaScript", "-e", clipboard_files_js }, { text = true }):wait(3000)
	local files = res.code == 0 and vim.split(vim.trim(res.stdout or ""), "\n", { trimempty = true }) or {}
	if #files == 0 or not vim.iter(files):all(is_image) then
		return nil
	end

	local dir = attachment_dir()
	vim.fn.mkdir(dir, "p")
	local embeds = {}
	for _, file in ipairs(files) do
		local ok, name = pcall(copy_in, file, dir)
		if not ok then
			vim.notify(("couldn't copy %s: %s"):format(file, name), vim.log.levels.ERROR)
			return nil
		end
		table.insert(embeds, ("![[%s]]"):format(name))
	end
	return embeds
end

local function enabled(buf)
	return vim.b[buf].year3_paste_image == true
end

local orig_paste
local function install_paste_hook()
	if orig_paste then
		return
	end
	orig_paste = vim.paste
	vim.paste = function(lines, phase)
		if phase == -1 and enabled(0) and could_be_filenames(lines) then
			local embeds = embeds_from_clipboard()
			if embeds then
				return orig_paste(embeds, phase)
			end
		end
		return orig_paste(lines, phase)
	end
end

-- turn it on for a markdown buffer, if it lives in the Year 3 vault
function M.attach(buf)
	local file = vim.fn.resolve(vim.api.nvim_buf_get_name(buf))
	if file:sub(1, #year3 + 1) ~= year3 .. "/" then
		return
	end
	vim.b[buf].year3_paste_image = true
	install_paste_hook()

	vim.keymap.set("n", "p", function()
		local reg = vim.v.register
		if reg == "+" or reg == "*" then
			local embeds = could_be_filenames({ vim.fn.getreg(reg) }) and embeds_from_clipboard()
			if embeds then
				vim.api.nvim_put(embeds, "l", true, true)
				return
			end
		end
		vim.cmd.normal({ vim.v.count1 .. '"' .. reg .. "p", bang = true })
	end, { buffer = buf, desc = "Paste (copied images go to attachments)" })
end

return M
