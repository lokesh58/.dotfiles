return {
    "stevearc/oil.nvim",
    lazy = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
        view_options = {
            show_hidden = true,
        },
        keymaps = {
            ["<S-h>"] = "actions.parent",
            ["<S-l>"] = "actions.select",
            ["q"] = "actions.close",
            ["<Esc>"] = "actions.close",
        },
    },
    keys = {
        { "-", "<cmd>Oil --preview<CR>", desc = "Open parent directory" },
    },
}
