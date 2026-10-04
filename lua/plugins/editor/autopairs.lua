return {
	{
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
			},
		},
		config = function(_, opts)
			local npairs = require("nvim-autopairs")
			npairs.setup(opts)

			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")

			-- latex autopair rules
			npairs.add_rules({
				Rule("\\(", "\\)", "tex"),
				Rule("\\[", "\\]", "tex"),
				Rule("\\{", "\\}", "tex"),
				Rule("\\langle", "\\rangle", "tex"),
				Rule("\\lfloor", "\\rfloor", "tex"),
				Rule("\\lceil", "\\rceil", "tex"),
				Rule("\\lvert", "\\rvert", "tex"),
				Rule("\\lVert", "\\rVert", "tex"),
				Rule("_", "{}", "tex"):set_end_pair_length(1):with_pair(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()
					return line:sub(col + 1, col + 1) ~= "{"
				end),
				Rule("^", "{}", "tex"):set_end_pair_length(1):with_pair(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local line = vim.api.nvim_get_current_line()
					return line:sub(col + 1, col + 1) ~= "{"
				end),
			})

			-- delimiters that also come doubled ($$, **, ~~). typing the char straight
			-- after an opener grows the pair ($|$ -> $$|$$) instead of skipping out;
			-- after text it skips one closing char, so typing $$ or ** closes cleanly.
			-- single_pair: extra condition for pairing the lone char, or false to only
			-- pair the doubled form.
			local function doubled(ch, ft, single_pair)
				local function after_opener(o)
					local before = o.line:sub(1, o.col - 1)
					return before:sub(-1) == ch and not before:sub(-2, -2):match("[%w%)%]}]")
				end
				local single = Rule(ch, ch, ft)
					:with_pair(cond.not_before_regex("\\", 1))
					:with_move(function(o)
						return not after_opener(o)
					end)
				if single_pair ~= nil then
					single:with_pair(single_pair or cond.none())
				end
				local double = Rule(ch .. ch, ch .. ch, ft):with_move(cond.none()):with_pair(function(o)
					return o.line:sub(o.col, o.col) ~= ch
				end)
				return { single, double }
			end

			local math_ft = { "tex", "plaintex", "markdown" }
			npairs.add_rules(doubled("$", math_ft))
			npairs.add_rules({
				Rule("\\left(", "\\right)", math_ft),
				Rule("\\left[", "\\right]", math_ft),
				Rule("\\left\\{", "\\right\\}", math_ft),
				Rule("\\left|", "\\right|", math_ft),
				Rule("\\{", "\\}", "markdown"),
				-- ``quotes'' in latex, replacing the default `…` and '…' pairs
				Rule("``", "''", { "tex", "plaintex" }),
				Rule("'", "'", { "tex", "plaintex" }):with_pair(cond.none()):with_move(function(o)
					return o.next_char == "'"
				end),
			})
			for _, ch in ipairs({ "`", "'" }) do
				for _, rule in ipairs(npairs.get_rules(ch)) do
					if rule.start_pair == ch and not rule.filetypes then
						rule.not_filetypes = vim.list_extend(rule.not_filetypes or {}, { "tex", "plaintex" })
					end
				end
			end

			-- markdown emphasis: *italic*, **bold**, _italic_, ~~strike~~, ==highlight==
			npairs.add_rules(doubled("*", "markdown", function(o)
				return o.line:sub(1, o.col - 1):match("^%s*$") == nil -- not a list bullet
			end))
			npairs.add_rules(doubled("_", "markdown", cond.not_before_regex("%w")))
			npairs.add_rules(doubled("~", "markdown", false))
			npairs.add_rules(doubled("=", "markdown", false))

			-- \begin{env} -> adds \end{env} on the line below once the name is closed.
			-- the cursor stays after the brace so [opts] / {args} can still be typed.
			vim.api.nvim_create_autocmd("CursorMovedI", {
				group = vim.api.nvim_create_augroup("AutoEndEnv", { clear = true }),
				callback = function(ev)
					if not vim.tbl_contains(math_ft, vim.bo[ev.buf].filetype) then
						return
					end
					local row, col = unpack(vim.api.nvim_win_get_cursor(0))
					local line = vim.api.nvim_get_current_line()
					local env = line:sub(1, col):match("\\begin{([^{}]+)}$")
					if not env or line:sub(col + 1):match("%S") then
						return
					end
					-- only when this \begin is unclosed (handles nesting the same env)
					local open, close = "\\begin{" .. env .. "}", "\\end{" .. env .. "}"
					local depth = 0
					for _, l in ipairs(vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)) do
						local _, b = l:gsub(vim.pesc(open), "")
						local _, e = l:gsub(vim.pesc(close), "")
						depth = depth + b - e
					end
					if depth > 0 then
						local indent = line:match("^%s*")
						vim.api.nvim_buf_set_lines(ev.buf, row, row, false, { indent .. close })
					end
				end,
			})
		end,
	},
}
