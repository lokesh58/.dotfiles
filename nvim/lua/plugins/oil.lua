return {
    'stevearc/oil.nvim',
    dependencies = { { "echasnovski/mini.icons"} },
    lazy = false,
    config = function()
        require("oil").setup({})
        vim.keymap.set("n", "-", "<cmd>Oil --float<cr>", {desc = "Open parent directory in oil"})
    end
}
