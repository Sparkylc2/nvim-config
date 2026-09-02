return {
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	ft = { "vue", "typescript", "javascript" },
	-- 	config = function()
	-- 		local old_notify = vim.notify
	-- 		vim.notify = function(msg, level, opts)
	-- 			if type(msg) == "string" and msg:find("`require%('lspconfig'%)`%s*\"framework\"%s*is%s*deprecated") then
	-- 				return
	-- 			end
	-- 			return old_notify(msg, level, opts)
	-- 		end
	--
	-- 		vim.notify = old_notify
	-- 	end,
	-- },
}
