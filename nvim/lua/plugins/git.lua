return {
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>gg",
                function()
                    require("snacks").lazygit()
                end,
                desc = "Lazygit",
            },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        opts = {
            auto_attach = true,
            attach_to_untracked = true,
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 300,
            },
        },
        keys = {
            { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", desc = "Git blame line" },
            { "<leader>gB", "<cmd>Gitsigns blame<CR>", desc = "Git blame file" },
            { "<leader>hp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Preview Git hunk in a popup" },
            { "<leader>hP", "<cmd>Gitsigns preview_hunk_inline<CR>", desc = "Preview Git hunk inline" },
            { "<leader>hr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset current Git hunk" },
            { "[H", "<cmd>Gitsigns nav_hunk last<CR>", desc = "Goto last Git hunk" },
            { "[h", "<cmd>Gitsigns nav_hunk prev<CR>", desc = "Goto previous Git hunk" },
            { "]h", "<cmd>Gitsigns nav_hunk next<CR>", desc = "Goto next Git hunk" },
            { "]H", "<cmd>Gitsigns nav_hunk first<CR>", desc = "Goto first Git hunk" },
        },
    },
    {
        "tpope/vim-fugitive"
    }
}
