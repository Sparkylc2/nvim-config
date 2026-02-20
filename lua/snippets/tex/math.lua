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
	s({ trig = "\\nali", dscr = "Align environment (no number)" }, {
		t({ "\\begin{align*}", "\t" }),
		i(1),
		t({ "", "\\end{align*}" }),
	}),
	s({ trig = "nali", dscr = "Align environment (no number)" }, {
		t({ "\\begin{align*}", "\t" }),
		i(1),
		t({ "", "\\end{align*}" }),
	}),

	s({ trig = "int", dscr = "Integral" }, {
		t("\\int_{"),
		i(1, "a"),
		t("}^{"),
		i(2, "b"),
		t("} "),
		i(3, "f(x)"),
		t(" \\, \\mathrm{d}"),
		i(4, "x"),
	}),
	s({ trig = "\\int", dscr = "Integral" }, {
		t("\\int_{"),
		i(1, "a"),
		t("}^{"),
		i(2, "b"),
		t("} "),
		i(3, "f(x)"),
		t(" \\, \\mathrm{d}"),
		i(4, "x"),
	}),

	s({ trig = "fx", dscr = "Function of " }, {
		f(function()
			return vim.fn["vimtex#syntax#in_mathzone"]() == 1 and "" or "\\("
		end),
		t("f("),
		i(1),
		t(") = "),
		i(2),
		f(function()
			return vim.fn["vimtex#syntax#in_mathzone"]() == 1 and "" or "\\)"
		end),
	}),
	s({ trig = "\\fx", dscr = "Function of " }, {
		f(function()
			return vim.fn["vimtex#syntax#in_mathzone"]() == 1 and "" or "\\("
		end),
		t("f("),
		i(1),
		t(") = "),
		i(2),
		f(function()
			return vim.fn["vimtex#syntax#in_mathzone"]() == 1 and "" or "\\)"
		end),
	}),

	s({ trig = "quad", dscr = "Quad Space" }, {
		t("\\quad"),
	}),

	s({ trig = "sqrt", dscr = "Square Root" }, {
		t("\\sqrt{"),
		i(1),
		t("}"),
	}),

	s({ trig = "pm", dscr = "Plus Minus" }, {
		t("\\pm"),
	}),

	s({ trig = "sin", dscr = "Sine function" }, {
		t("\\sin{"),
		i(1),
		t("}"),
	}),

	s({ trig = "psin", dscr = "Sine function (parenthesis)" }, {
		t("\\sin("),
		i(1),
		t(")"),
	}),

	s({ trig = "cos", dscr = "Cosine function" }, {
		t("\\cos{"),
		i(1),
		t("}"),
	}),

	s({ trig = "pcos", dscr = "Cosine function (parenthesis)" }, {
		t("\\cos("),
		i(1),
		t(")"),
	}),

	s({ trig = "tan", dscr = "Tangent function" }, {
		t("\\tan{"),
		i(1),
		t("}"),
	}),

	s({ trig = "ptan", dscr = "Tangent function (parenthesis)" }, {
		t("\\tan("),
		i(1),
		t(")"),
	}),
	s({ trig = "\\ptan", dscr = "Tangent function (parenthesis)" }, {
		t("\\tan("),
		i(1),
		t(")"),
	}),

	s({ trig = "exp", dscr = "Exponential function" }, {
		t("\\exp{"),
		i(1),
		t("}"),
	}),
	s({ trig = "\\exp", dscr = "Exponential function" }, {
		t("\\exp{"),
		i(1),
		t("}"),
	}),

	s({ trig = "ln", dscr = "Natural logarithm" }, {
		t("\\ln{"),
		i(1),
		t("}"),
	}),
	s({ trig = "lnp", dscr = "Natural logarithm (parenthesis)" }, {
		t("\\ln({"),
		i(1),
		t("})"),
	}),

	s({ trig = "hat", dscr = "Hat accent" }, {
		t("\\hat{"),
		i(1),
		t("}"),
	}),
	s({ trig = "\\hat", dscr = "Hat accent" }, {
		t("\\hat{"),
		i(1),
		t("}"),
	}),

	s({ trig = "te", dscr = "Text" }, {
		t("\\text{"),
		i(1),
		t("}"),
	}),
	s({ trig = "\\te", dscr = "Text" }, {
		t("\\text{"),
		i(1),
		t("}"),
	}),

	s({ trig = "cdot", dscr = "cdot" }, {
		t("\\cdot"),
	}),
	s({ trig = "\\cdot", dscr = "cdot" }, {
		t("\\cdot"),
	}),

	s({ trig = "vec", dscr = "Vector line" }, {
		t("\\vec{"),
		i(1),
		t("}"),
	}),
	s({ trig = "\\vec", dscr = "Vector line" }, {
		t("\\vec{"),
		i(1),
		t("}"),
	}),

	s({ trig = "odf", dscr = "Ordinary differential fraction" }, {
		t("\\frac{\\mathrm{d}{"),
		i(1),
		t("}}{\\mathrm{d}{"),
		i(2),
		t("}}"),
	}),
	s({ trig = "\\odf", dscr = "Ordinary differential fraction" }, {
		t("\\frac{\\mathrm{d}{"),
		i(1),
		t("}}{\\mathrm{d}{"),
		i(2),
		t("}}"),
	}),

	s({ trig = "nodf", dscr = "Ordinary differential fraction (nth)" }, {
		t("\\frac{\\mathrm{d}^{"),
		i(1, "n"),
		t("}{"),
		i(2),
		t("}}{\\mathrm{d}{"),
		i(3),
		t("}^{"),
		rep(1),
		t("}}"),
	}),
	s({ trig = "\\nodf", dscr = "Ordinary differential fraction (nth)" }, {
		t("\\frac{\\mathrm{d}^{"),
		i(1, "n"),
		t("}{"),
		i(2),
		t("}}{\\mathrm{d}{"),
		i(3),
		t("}^{"),
		rep(1),
		t("}}"),
	}),
	s({ trig = "pdf", dscr = "Partial differential" }, {
		t("\\frac{\\partial{"),
		i(1),
		t("}}{\\partial{"),
		i(2),
		t("}}"),
	}),
	s({ trig = "\\pdf", dscr = "Partial differential" }, {
		t("\\frac{\\partial{"),
		i(1),
		t("}}{\\partial{"),
		i(2),
		t("}}"),
	}),

	s({ trig = "npdf", dscr = "Partial differential (nth)" }, {
		t("\\frac{\\partial^{"),
		i(1, "n"),
		t("}{"),
		i(2),
		t("}}{\\partial{"),
		i(3),
		t("}^{"),
		rep(1),
		t("}}"),
	}),
	s({ trig = "\\npdf", dscr = "Partial differential (nth)" }, {
		t("\\frac{\\partial^{"),
		i(1, "n"),
		t("}{"),
		i(2),
		t("}}{\\partial{"),
		i(3),
		t("}^{"),
		rep(1),
		t("}}"),
	}),

	-- Math mode
	s({ trig = "mm", dscr = "Math mode" }, {
		t("\\[ "),
		i(1),
		t(" \\]"),
	}),
	s({ trig = "im", dscr = "Inline Math mode" }, {
		t("\\( "),
		i(1),
		t(" \\)"),
	}),

	s({ trig = "eq", dscr = "Equation environment" }, {
		t({ "\\begin{equation}", "\t" }),
		i(1),
		t({ "", "\\end{equation}" }),
	}),
	s({ trig = "neq", dscr = "Equation environment (no number)" }, {
		t({ "\\begin{equation*}", "\t" }),
		i(1),
		t({ "", "\\end{equation*}" }),
	}),

	s({ trig = "eqa", dscr = "Equation with aligned" }, {
		t({ "\\begin{equation}", "\t\\begin{aligned}", "\t\t" }),
		i(1),
		t({ "", "\t\\end{aligned}", "\\end{equation}" }),
	}),
	s({ trig = "neqa", dscr = "Equation with aligned (no number)" }, {
		t({ "\\begin{equation*}", "\t\\begin{aligned}", "\t\t" }),
		i(1),
		t({ "", "\t\\end{aligned}", "\\end{equation*}" }),
	}),

	s({ trig = "mbf", dscr = "Math bold" }, {
		t({ "\\mathbf{" }),
		i(1),
		t({ "}" }),
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

	-- Autosized delimiters mode
	s({ trig = "lrp", dscr = "Sized parenthesis" }, {
		t("\\left("),
		i(1),
		t("\\right)"),
	}),
	s({ trig = "lrb", dscr = "Sized rized brackets" }, {
		t("\\left["),
		i(1),
		t("\\right]"),
	}),
	s({ trig = "lrcb", dscr = "Sized curly brackets" }, {
		t("\\left{"),
		i(1),
		t("\\right}"),
	}),

	-- Autosized delimiter pair
	s({ trig = "lr", dscr = "Sized delimiter pair" }, {
		t("\\left"),
		i(1, "("),
		t(" "),
		i(2),
		t(" "),
		t("\\right"),
		f(function(args)
			local delimiter = args[1][1]
			-- if delimiter starts with '\l', replace with '\r'
			if delimiter:sub(1, 2) == "\\l" then
				return "\\r" .. delimiter:sub(3)
			end

			return delimiter
		end, { 1 }),
	}),
	-- Symbols
	s({ trig = "nab", dscr = "nabla" }, t("\\nabla ")),
	s({ trig = "Nab", dscr = "Nabla" }, t("\\Nabla ")),
	s({ trig = "times", dscr = "times" }, t("\\times ")),
	s({ trig = "cdot", dscr = "cdot" }, t("\\cdot ")),
	s({ trig = "inf", dscr = "infinity" }, t("\\infty ")),
	s({ trig = "grad", dscr = "gradient" }, t("\\nabla ")),
	-- Symbols with \
	s({ trig = "\\nab", dscr = "nabla" }, t("\\nabla ")),
	s({ trig = "\\Nab", dscr = "Nabla" }, t("\\Nabla ")),
	s({ trig = "\\times", dscr = "times" }, t("\\times ")),
	s({ trig = "\\cdot", dscr = "cdot" }, t("\\cdot ")),
	s({ trig = "\\inf", dscr = "infinity" }, t("\\infty ")),
	s({ trig = "\\grad", dscr = "gradient" }, t("\\nabla ")),

	-- Greek letters
	s({ trig = "alp", dscr = "alpha" }, t("\\alpha ")),
	s({ trig = "bet", dscr = "beta" }, t("\\beta ")),
	s({ trig = "gam", dscr = "gamma" }, t("\\gamma ")),
	s({ trig = "del", dscr = "delta" }, t("\\delta ")),
	s({ trig = "eps", dscr = "epsilon" }, t("\\epsilon ")),
	s({ trig = "la", dscr = "lambda" }, t("\\lambda ")),
	s({ trig = "mu", dscr = "mu" }, t("\\mu ")),
	s({ trig = "pi", dscr = "pi" }, t("\\pi ")),
	s({ trig = "sig", dscr = "sigma" }, t("\\sigma ")),
	s({ trig = "ome", dscr = "omega" }, t("\\omega ")),
	s({ trig = "the", dscr = "theta" }, t("\\theta ")),
	s({ trig = "psi", dscr = "psi" }, t("\\psi ")),
	s({ trig = "phi", dscr = "phi" }, t("\\phi ")),

	s({ trig = "Alp", dscr = "Alpha" }, t("\\Alpha ")),
	s({ trig = "Bet", dscr = "Beta" }, t("\\Beta ")),
	s({ trig = "Gam", dscr = "Gamma" }, t("\\Gamma ")),
	s({ trig = "Del", dscr = "Delta" }, t("\\Delta ")),
	s({ trig = "Eps", dscr = "Epsilon" }, t("\\Epsilon ")),
	s({ trig = "La", dscr = "Lambda" }, t("\\Lambda ")),
	s({ trig = "Mu", dscr = "Mu" }, t("\\Mu ")),
	s({ trig = "Pi", dscr = "Pi" }, t("\\Pi ")),
	s({ trig = "Sig", dscr = "Sigma" }, t("\\Sigma ")),
	s({ trig = "Ome", dscr = "Omega" }, t("\\Omega ")),
	s({ trig = "The", dscr = "Theta" }, t("\\Theta ")),
	s({ trig = "Psi", dscr = "Psi" }, t("\\Psi ")),
	s({ trig = "Phi", dscr = "Phi" }, t("\\Phi ")),

	-- Greek letters with \
	s({ trig = "\\alp", dscr = "alpha" }, t("\\alpha ")),
	s({ trig = "\\bet", dscr = "beta" }, t("\\beta ")),
	s({ trig = "\\gam", dscr = "gamma" }, t("\\gamma ")),
	s({ trig = "\\del", dscr = "delta" }, t("\\delta ")),
	s({ trig = "\\eps", dscr = "epsilon" }, t("\\epsilon ")),
	s({ trig = "\\la", dscr = "lambda" }, t("\\lambda ")),
	s({ trig = "\\mu", dscr = "mu" }, t("\\mu ")),
	s({ trig = "\\pi", dscr = "pi" }, t("\\pi ")),
	s({ trig = "\\sig", dscr = "sigma" }, t("\\sigma ")),
	s({ trig = "\\ome", dscr = "omega" }, t("\\omega ")),
	s({ trig = "\\the", dscr = "theta" }, t("\\theta ")),
	s({ trig = "\\psi", dscr = "psi" }, t("\\psi ")),
	s({ trig = "\\phi", dscr = "phi" }, t("\\phi ")),
	s({ trig = "\\Alp", dscr = "Alpha" }, t("\\Alpha ")),
	s({ trig = "\\Bet", dscr = "Beta" }, t("\\Beta ")),
	s({ trig = "\\Gam", dscr = "Gamma" }, t("\\Gamma ")),
	s({ trig = "\\Del", dscr = "Delta" }, t("\\Delta ")),
	s({ trig = "\\Eps", dscr = "Epsilon" }, t("\\Epsilon ")),
	s({ trig = "\\La", dscr = "Lambda" }, t("\\Lambda ")),
	s({ trig = "\\Mu", dscr = "Mu" }, t("\\Mu ")),
	s({ trig = "\\Pi", dscr = "Pi" }, t("\\Pi ")),
	s({ trig = "\\Sig", dscr = "Sigma" }, t("\\Sigma ")),
	s({ trig = "\\Ome", dscr = "Omega" }, t("\\Omega ")),
	s({ trig = "\\The", dscr = "Theta" }, t("\\Theta ")),
	s({ trig = "\\Psi", dscr = "Psi" }, t("\\Psi ")),
	s({ trig = "\\Phi", dscr = "Phi" }, t("\\Phi ")),

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
	s({ trig = "bmat", dscr = "Matrix" }, {
		t({ "\\begin{bmatrix}", "\t" }),
		i(1),
		t({ "", "\\end{bmatrix}" }),
	}),
	s({ trig = "pmat", dscr = "Parenthesis matrix" }, {
		t({ "\\begin{pmatrix}", "\t" }),
		i(1),
		t({ "", "\\end{pmatrix}" }),
	}),
	s({ trig = "vmat", dscr = "Vert matrix" }, {
		t({ "\\begin{vmatrix}", "\t" }),
		i(1),
		t({ "", "\\end{vmatrix}" }),
	}),
}
