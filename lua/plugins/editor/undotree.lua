function test(nice)
	local x = "what do we do"
	local y = "what dont we do"

	local yes = x == y
	return yes
end
return {
	{
		"XXiaoA/atone.nvim",
		cmd = "Atone",
		opts = {},
		keys = {
			{ "<leader>u", "<cmd>Atone toggle<cr>" },
		},
	},
}
