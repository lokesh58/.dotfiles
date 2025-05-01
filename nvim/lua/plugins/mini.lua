return {
    "echasnovski/mini.nvim",
    config = function()
        -- Text Editing
        require("mini.ai").setup({ n_lines = 500 })
        require("mini.pairs").setup({
            modes = { insert = true, command = false, terminal = false },
            -- skip autopair when next character is one of these
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            -- skip autopair when the cursor is inside these treesitter nodes
            skip_ts = { "string" },
            -- skip autopair when next character is closing pair
            -- and there are more closing pairs than opening pairs
            skip_unbalanced = true,
            -- better deal with markdown code blocks
            markdown = true,
        })
        require("mini.surround").setup({
            mappings = {
                add = "ys", -- Add surrounding in Normal and Visual modes
                delete = "ds", -- Delete surrounding
                find = "", -- Find surrounding (to the right)
                find_left = "", -- Find surrounding (to the left)
                highlight = "", -- Highlight surrounding
                replace = "cs", -- Replace surrounding
                update_n_lines = "", -- Update `n_lines`

                suffix_last = "l", -- Suffix to search with "prev" method
                suffix_next = "n", -- Suffix to search with "next" method
            },
        })
        vim.keymap.set("n", "yss", "ys_", { remap = true })

        -- Appearance
        require("mini.icons").setup()
        require("mini.statusline").setup()
        vim.opt.showmode = false
    end,
}
