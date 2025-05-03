return {
    { "echasnovski/mini.ai", opts = { n_lines = 500 } },
    {
        "echasnovski/mini.pairs",
        opts = {
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
        },
    },
    {
        "echasnovski/mini.surround",
        opts = {
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
        },
    },
    {
        "echasnovski/mini.statusline",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        config = function(_, opts)
            require("mini.statusline").setup(opts)
            vim.opt.showmode = false
        end,
    },
}
