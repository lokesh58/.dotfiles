--------------------------------------------------------------------------------------------
-- Setup editor
--------------------------------------------------------------------------------------------

vim.opt.confirm = true
vim.opt.fixendofline = true
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.undofile = true
vim.opt.updatetime = 250

--------------------------------------------------------------------------------------------
-- Setup basic UI
--------------------------------------------------------------------------------------------

vim.opt.breakindent = true
vim.opt.cursorline = true
vim.opt.inccommand = "split"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = "↵" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.showcmdloc = "statusline"
vim.opt.signcolumn = "yes"
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.wrap = false

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

--------------------------------------------------------------------------------------------
-- Setup indentation
--------------------------------------------------------------------------------------------

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

--------------------------------------------------------------------------------------------
-- Setup search
--------------------------------------------------------------------------------------------

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.smartcase = true

--------------------------------------------------------------------------------------------
-- Setup diagnostics
--------------------------------------------------------------------------------------------
vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    },
    virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
})

--------------------------------------------------------------------------------------------
-- Setup shell
--------------------------------------------------------------------------------------------
if vim.loop.os_uname().sysname == "Windows_NT" then
    vim.o.shell = "pwsh.exe"
end
