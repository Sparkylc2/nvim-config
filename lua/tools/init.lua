-- language-specific tooling

local M = {}

local languages = {
	"cpp",
}

function M.setup()
	for _, lang in ipairs(languages) do
		local mod = "tools." .. lang
		local ok, result = pcall(require, mod)

		if not ok then
			vim.notify(("%s failed to load:\n%s"):format(mod, result), vim.log.levels.ERROR)
		elseif type(result) ~= "table" then
			vim.notify(("%s returned %s, expected a table"):format(mod, type(result)), vim.log.levels.ERROR)
		elseif type(result.setup) ~= "function" then
			vim.notify(("%s has no setup() function"):format(mod), vim.log.levels.ERROR)
		else
			local ok_setup, err = pcall(result.setup)
			if not ok_setup then
				vim.notify(("%s.setup() errored:\n%s"):format(mod, err), vim.log.levels.ERROR)
			end
		end
	end
end

return M
