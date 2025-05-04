return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
                    {
                        icon = " ",
                        key = "g",
                        desc = "Find Text",
                        action = ":lua Snacks.dashboard.pick('live_grep')",
                    },
                    {
                        icon = " ",
                        key = "o",
                        desc = "Recent (Old) Files",
                        action = ":lua Snacks.dashboard.pick('oldfiles')",
                    },
                    {
                        icon = " ",
                        key = "c",
                        desc = "Config",
                        action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config')})",
                    },
                    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
                header = table.concat({
                    [[                                                                     ]],
                    [[       ████ ██████           █████      ██                     ]],
                    [[      ███████████             █████                             ]],
                    [[      █████████ ███████████████████ ███   ███████████   ]],
                    [[     █████████  ███    █████████████ █████ ██████████████   ]],
                    [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
                    [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
                    [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
                }, "\n"),
            },
        },
        image = { enabled = true },
        indent = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true, folds = { open = true, git_hl = true } },
    },
    keys = {
        -- buffer
        {
            "<leader>bd",
            function()
                Snacks.bufdelete()
            end,
            desc = "Close current buffer",
        },
        {
            "<leader>bo",
            function()
                Snacks.bufdelete.other()
            end,
            desc = "Close all other buffers",
        },
        {
            "<leader>ba",
            function()
                Snacks.bufdelete.all()
            end,
            desc = "Close all buffers",
        },

        -- git
        {
            "<leader>gg",
            function()
                Snacks.lazygit()
            end,
            desc = "Lazygit",
        },

        -- misc
        {
            "<leader>e",
            function()
                Snacks.explorer({ hidden = true, ignored = true })
            end,
            desc = "Open file explorer",
        },
        {
            "<leader>n",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "Notification History",
        },
        {
            "<leader>tt",
            function()
                Snacks.terminal()
            end,
            desc = "Toggle Terminal",
        },
    },
}
