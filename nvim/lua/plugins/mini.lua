return {
    "echasnovski/mini.nvim",
    config = function()
        -- Text Editing
        require("mini.ai").setup()
        require("mini.surround").setup()

        -- Appearance
        require("mini.icons").setup()
        require("mini.statusline").setup()
        vim.opt.showmode = false
    end,
}
