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
    -- Basic snippets
    s({ trig = "tt", dscr = "Expands 'tt' into '\\texttt{}'" }, {
        t("\\texttt{"), i(1), t("}"),
    }),

    s({ trig = "tit", dscr = "Expands 'tit' into '\\textit{}'" }, {
        t("\\textit{"), i(1), t("}"),
    }),

    s({ trig = "tbf", dscr = "Expands 'tbf' into '\\textbf{}'" }, {
        t("\\textbf{"), i(1), t("}"),
    }),

    -- Math mode
    s({ trig = "mm", dscr = "Math mode" }, {
        t("$"), i(1), t("$"),
    }),

    s({ trig = "dm", dscr = "Display math" }, {
        t({ "\\[", "\t" }), i(1), t({ "", "\\]" }),
    }),

    -- Fractions
    s({ trig = "ff", dscr = "Fraction" }, {
        t("\\frac{"), i(1), t("}{"), i(2), t("}"),
    }),

    -- Environments
    s({ trig = "beg", dscr = "Begin environment" }, {
        t("\\begin{"), i(1, "environment"), t({ "}", "\t" }),
        i(0),
        t({ "", "\\end{" }), rep(1), t("}"),
    }),

    s({ trig = "eq", dscr = "Equation environment" }, {
        t({ "\\begin{equation}", "\t" }),
        i(1),
        t({ "", "\\end{equation}" }),
    }),

    s({ trig = "ali", dscr = "Align environment" }, {
        t({ "\\begin{align}", "\t" }),
        i(1),
        t({ "", "\\end{align}" }),
    }),

    -- Sections
    s({ trig = "sec", dscr = "Section" }, {
        t("\\section{"), i(1), t("}"),
    }),

    s({ trig = "ssec", dscr = "Subsection" }, {
        t("\\subsection{"), i(1), t("}"),
    }),

    s({ trig = "sssec", dscr = "Subsubsection" }, {
        t("\\subsubsection{"), i(1), t("}"),
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
        t("^{"), i(1), t("}"),
    }),

    s({ trig = "__", dscr = "Subscript" }, {
        t("_{"), i(1), t("}"),
    }),

    -- Common commands
    s({ trig = "sum", dscr = "Sum" }, {
        t("\\sum_{"), i(1, "i=1"), t("}^{"), i(2, "n"), t("}"),
    }),

    s({ trig = "int", dscr = "Integral" }, {
        t("\\int_{"), i(1, "a"), t("}^{"), i(2, "b"), t("}"),
    }),

    s({ trig = "lim", dscr = "Limit" }, {
        t("\\lim_{"), i(1, "x \\to \\infty"), t("}"),
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

    -- References
    s({ trig = "ref", dscr = "Reference" }, {
        t("\\ref{"), i(1), t("}"),
    }),

    s({ trig = "lab", dscr = "Label" }, {
        t("\\label{"), i(1), t("}"),
    }),

    s({ trig = "cite", dscr = "Citation" }, {
        t("\\cite{"), i(1), t("}"),
    }),
}
