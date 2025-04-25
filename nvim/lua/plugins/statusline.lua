return {
    'echasnovski/mini.statusline',
    config = function()
        require('mini.statusline').setup({
            use_icons = vim.g.have_nerd_font
        })
        vim.opt.showmode = false -- Don't show the mode, since it's already in the status line
    end
}
