local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--------------------------------------------------------------------------------------------
-- editor related
--------------------------------------------------------------------------------------------

vim.keymap.set("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" })
vim.keymap.set("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move lines up in visual selection" })

-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move up in buffer with cursor centered" })
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move down in buffer with cursor centered" })

-- keep visual selection while changing indentation of selected text
vim.keymap.set("x", "<", "<gv", opts)
vim.keymap.set("x", ">", ">gv", opts)

vim.keymap.set(
    "n",
    "<leader>sr",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word cursor is on globally" }
)
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Close neovim" })

-- delete / change / paste without affecting clipboard
vim.keymap.set("x", "<leader>p", [["_dp]])
vim.keymap.set({ "n", "x" }, "<leader>s", [["_s]])
vim.keymap.set({ "n", "x" }, "<leader>c", [["_c]])
vim.keymap.set({ "n", "x" }, "<leader>d", [["_d]])

--------------------------------------------------------------------------------------------
-- search related
--------------------------------------------------------------------------------------------

-- keep cursor centered when navigating search results
vim.keymap.set("n", "n", "nzzzv") -- cspell: disable-line
vim.keymap.set("n", "N", "Nzzzv") -- cspell: disable-line

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })
vim.keymap.set("n", "<C-c>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

--------------------------------------------------------------------------------------------
-- tab related
--------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current tab in new tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Goto next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Goto previous tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })

--------------------------------------------------------------------------------------------
-- window related
--------------------------------------------------------------------------------------------

vim.keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make windows equal size" })
vim.keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Increase window height" })
vim.keymap.set("n", "<M-l>", "<C-w>>", { desc = "Increase window width" })
vim.keymap.set("n", "<M-h>", "<C-w><", { desc = "Decrease window width" })
vim.keymap.set("n", "<M-j>", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<M-k>", "<C-w>+", { desc = "Increase window height" })
