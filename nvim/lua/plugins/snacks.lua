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
        picker = { enabled = true },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
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

        -- picker
        {
            "<leader>ff",
            function()
                require("snacks").picker.files()
            end,
            desc = "Find Files",
        },
        {
            "<leader>fo",
            function()
                require("snacks").picker.recent()
            end,
            desc = "Find Recent (Old) Files",
        },
        {
            "<leader>fc",
            function()
                require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find in Config",
        },
        {
            "<leader>fg",
            function()
                require("snacks").picker.grep()
            end,
            desc = "Grep",
        },
        {
            "<leader>fw",
            function()
                require("snacks").picker.grep_word()
            end,
            desc = "Grep word",
        },
        {
            "<leader>fv",
            function()
                require("snacks").picker.grep_word()
            end,
            desc = "Grep visual selection",
            mode = "x",
        },
        {
            "<leader>/",
            function()
                require("snacks").picker.lines()
            end,
            desc = "Grep current Buffer",
        },
        {
            "<leader><leader>",
            function()
                require("snacks").picker.buffers()
            end,
            desc = "Search open Buffers",
        },
        {
            "<leader>fh",
            function()
                require("snacks").picker.help()
            end,
            desc = "Search Help",
        },
        {
            "<leader>fm",
            function()
                require("snacks").picker.marks()
            end,
            desc = "Marks",
        },
        {
            "<leader>fr",
            function()
                require("snacks").picker.resume()
            end,
            desc = "Resume last search",
        },
        {
            "<leader>fa",
            function()
                require("snacks").picker()
            end,
            desc = "All Picker",
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
                Snacks.explorer()
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
            "<C-`>",
            function()
                Snacks.terminal()
            end,
            mode = { "n", "t" },
            desc = "Toggle Terminal",
        },
    },
}
