local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local function in_mathzone()
	return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

return {

	s({ trig = "tt", dscr = "Expands 'tt' into '\\texttt{}'" }, {
		t("\\texttt{"),
		i(1),
		t("}"),
	}),

	s({ trig = "it", dscr = "Expands 'tit' into '\\textit{}' or '\\mathit{}'" }, {
		d(1, function()
			if in_mathzone() then
				return sn(nil, { t("\\mathit{"), i(1), t("}") })
			else
				return sn(nil, { t("\\textit{"), i(1), t("}") })
			end
		end),
	}),
	s({ trig = "bf", dscr = "Expands 'bf' into '\\textbf{}' or '\\mathbf{}'" }, {
		d(1, function()
			if in_mathzone() then
				return sn(nil, { t("\\mathbf{"), i(1), t("}") })
			else
				return sn(nil, { t("\\textbf{"), i(1), t("}") })
			end
		end),
	}),

	-- Environments
	s({ trig = "begin", dscr = "Begin environment" }, {
		t("\\begin{"),
		i(1, "environment"),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t("}"),
	}),
	s({ trig = "\\begin", dscr = "Begin environment" }, {
		t("\\begin{"),
		i(1, "environment"),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t("}"),
	}),
	s({ trig = "beg", dscr = "Begin environment" }, {
		t("\\begin{"),
		i(1, "environment"),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t("}"),
	}),
	s({ trig = "\\beg", dscr = "Begin environment" }, {
		t("\\begin{"),
		i(1, "environment"),
		t({ "}", "\t" }),
		i(0),
		t({ "", "\\end{" }),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t("}"),
	}),
	s({ trig = "md", dscr = "Begin markdown environment" }, {
		t({ "\\begin{markdown}", "" }),
		i(1, "markdown"),
		t({ "", "\\end{markdown}" }),
	}),
	-- Sections
	s({ trig = "sec", dscr = "Section" }, {
		t("\\section{"),
		i(1),
		t("}"),
	}),

	s({ trig = "ssec", dscr = "Subsection" }, {
		t("\\subsection{"),
		i(1),
		t("}"),
	}),

	s({ trig = "sssec", dscr = "Subsubsection" }, {
		t("\\subsubsection{"),
		i(1),
		t("}"),
	}),

	-- References
	s({ trig = "fref", dscr = "Figure Reference" }, {
		t("\\figref{"),
		i(1),
		t("}"),
	}),

	s({ trig = "eref", dscr = "Equation Reference" }, {
		t("\\eqref{"),
		i(1),
		t("}"),
	}),

	s({ trig = "tref", dscr = "Table Reference" }, {
		t("\\tableref{"),
		i(1),
		t("}"),
	}),

	s({ trig = "ref", dscr = "Reference" }, {
		t("\\ref{"),
		i(1),
		t("}"),
	}),

	s({ trig = "lab", dscr = "Label" }, {
		t("\\label{"),
		i(1),
		t("}"),
	}),

	s({ trig = "cite", dscr = "Citation" }, {
		t("\\cite{"),
		i(1),
		t("}"),
	}),
}
