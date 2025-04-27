return {
    'echasnovski/mini.statusline',
    dependencies = {"nvim-tree/nvim-web-devicons"},
    opts = {},
    config = function(_, opts)
        require('mini.statusline').setup(opts)
        vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
    end
}
