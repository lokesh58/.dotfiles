return {
    {
        "folke/snacks.nvim",
        opts = {
            bigfile = {
                enabled = true,
            },
            notifier = {
                enabled = true,
            },
            image = {
                enabled = true,
            },
            indent = {
                enabled = true,
            },
            quickfile = {
                enabled = true,
            },
            scroll = {
                enabled = true,
            },
        },
        keys = {
            {
                "<leader>n",
                function()
                    require("snacks").notifier.show_history()
                end,
                desc = "Notification History",
            },
        },
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = true,
                inc_rename = true,
                lsp_doc_border = true,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                },
            },
        },
    },
}
