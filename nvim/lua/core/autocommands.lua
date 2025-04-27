-- -- cd into the opened folder
-- vim.api.nvim_create_autocmd("VimEnter", {
--     desc = "cd into the opened folder or parent directory of opened file on startup",
--     group = vim.api.nvim_create_augroup('auto-cd-pwd', { clear = true }),
--     callback = function()
--         if vim.fn.argc() == 1 then
--             local target_dir = vim.fn.expand("%:p:h")
--             -- Oil changes the buffer name, remove the added prefix
--             if string.sub(target_dir, 1, #"oil://") == "oil://" then
--                 target_dir = string.sub(target_dir, 7)
--             end
--             if vim.fn.isdirectory(target_dir) ~= 0 then
--                 vim.api.nvim_set_current_dir(target_dir)
--             end
--         end
--     end
-- })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
