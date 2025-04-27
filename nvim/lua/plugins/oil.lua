return {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
        view_options = {
            show_hidden = true
        },
        keymaps = {
            ['q'] = {"actions.close", mode='n', desc = "Close Oil"},
        }
    },
    keys = {
        {
            "-",
            "<cmd>Oil<cr>",
            desc = "Open parent directory in oil"
        }
    }
}
