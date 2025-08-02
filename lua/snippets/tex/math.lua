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

return {

	-- Math mode
	s({ trig = "mm", dscr = "Math mode" }, {
		t("\\["),
		i(1),
		t("\\]"),
	}),

	s({ trig = "eq", dscr = "Equation environment" }, {
		t({ "\\begin{equation}", "\t" }),
		i(1),
		t({ "", "\\end{equation}" }),
	}),

	s({ trig = "eqa", dscr = "Equation with aligned" }, {
		t({ "\\begin{equation}", "\t\\begin{aligned}", "\t\t" }),
		i(1),
		t({ "", "\t\\end{aligned}", "\\end{equation}" }),
	}),

	-- Fractions
	s({ trig = "ff", dscr = "Fraction" }, {
		t("\\frac{"),
		i(1),
		t("}{"),
		i(2),
		t("}"),
	}),

	s({ trig = "ali", dscr = "Align environment" }, {
		t({ "\\begin{align}", "\t" }),
		i(1),
		t({ "", "\\end{align}" }),
	}),

	-- Greek letters
	s({ trig = ";a", dscr = "alpha" }, t("\\alpha")),
	s({ trig = ";b", dscr = "beta" }, t("\\beta")),
	s({ trig = ";g", dscr = "gamma" }, t("\\gamma")),
	s({ trig = ";d", dscr = "delta" }, t("\\delta")),
	s({ trig = ";e", dscr = "epsilon" }, t("\\epsilon")),
	s({ trig = ";l", dscr = "lambda" }, t("\\lambda")),
	s({ trig = ";m", dscr = "mu" }, t("\\mu")),
	s({ trig = ";p", dscr = "pi" }, t("\\pi")),
	s({ trig = ";s", dscr = "sigma" }, t("\\sigma")),
	s({ trig = ";t", dscr = "theta" }, t("\\theta")),

	-- Superscript and subscript
	s({ trig = "sr", dscr = "Square" }, {
		t("^{2}"),
	}),

	s({ trig = "cb", dscr = "Cube" }, {
		t("^{3}"),
	}),

	s({ trig = "td", dscr = "Superscript" }, {
		t("^{"),
		i(1),
		t("}"),
	}),

	s({ trig = "__", dscr = "Subscript" }, {
		t("_{"),
		i(1),
		t("}"),
	}),

	-- Common commands
	s({ trig = "sum", dscr = "Sum" }, {
		t("\\sum_{"),
		i(1, "i=1"),
		t("}^{"),
		i(2, "n"),
		t("}"),
	}),

	s({ trig = "int", dscr = "Integral" }, {
		t("\\int_{"),
		i(1, "a"),
		t("}^{"),
		i(2, "b"),
		t("}"),
		t(" "),
		i(3, "f(x)"),
		t(" \\, \\mathrm{d}"),
		i(4, "x"),
	}),

	s({ trig = "lim", dscr = "Limit" }, {
		t("\\lim_{"),
		i(1, "x \\to \\infty"),
		t("}"),
	}),

	-- Matrices
	s({ trig = "mat", dscr = "Matrix" }, {
		t({ "\\begin{bmatrix}", "\t" }),
		i(1),
		t({ "", "\\end{bmatrix}" }),
	}),

	s({ trig = "pmat", dscr = "Parenthesis matrix" }, {
		t({ "\\begin{pmatrix}", "\t" }),
		i(1),
		t({ "", "\\end{pmatrix}" }),
	}),
}
