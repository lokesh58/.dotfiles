-- search related
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- window related
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- editor related
vim.keymap.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Close neovim" })

-- diagnostics related
vim.keymap.set("n", "grl", vim.diagnostic.open_float, { desc = "Open line diagnostics" })
