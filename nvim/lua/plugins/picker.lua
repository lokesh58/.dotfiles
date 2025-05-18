return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                enabled = true,
            },
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("snacks").picker.files()
                end,
                desc = "Find Files",
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
                "<leader>f/",
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
        },
    },
}
