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
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
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
