return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        ---@module "oil"
        ---@type oil.SetupOpts
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            lsp_file_methods = {
                enabled = true,
                autosave_changes = "unmodified",
            },
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["<M-h>"] = "actions.parent",
                ["<M-l>"] = "actions.select",
                ["q"] = "actions.close",
            },
        },
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
            { "<leader>-", "<cmd>Oil --float<CR>", desc = "Open parent directory (floating)" },
        },
    },
    {
        "echasnovski/mini.files",
        opts = {
            mappings = {
                go_in = "<CR>",
                go_in_plus = "<M-l>",
                go_out = "-",
                go_out_plus = "<M-h>",
            },
            options = {
                use_as_default_explorer = false,
            },
        },
        keys = {
            { "<leader>ee", function() require("mini.files").open() end, { desc = "Open mini files explorer" } },
            { "<leader>ef", function()
                require("mini.files").open(vim.api.nvim_buf_get_name(0), false)
                require("mini.files").reveal_cwd()
            end, { desc = "Open mini files explorer into current open file" } },
        },
    },
    {
        "folke/snacks.nvim",
        keys = {
            {
                "<leader>es",
                function()
                    require("snacks").explorer()
                end,
                desc = "Open snacks file explorer",
            },
        },
    },
}
