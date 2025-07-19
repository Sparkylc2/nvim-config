local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Remove whitespace on save
augroup("RemoveWhitespace", { clear = true })
autocmd("BufWritePre", {
    group = "RemoveWhitespace",
    pattern = "*",
    callback = function()
        vim.cmd([[%s/\s\+$//e]])
    end,
})

-- Language specific settings
augroup("FileTypeSettings", { clear = true })

-- JavaScript/TypeScript
autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Python
autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = "python",
    callback = function()
        vim.opt_local.colorcolumn = "88"
    end,
})

-- C/C++
autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.commentstring = "// %s"
    end,
})

-- Markdown
autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
    group = "FileTypeSettings",
    pattern = {
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "startuptime",
        "checkhealth",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
