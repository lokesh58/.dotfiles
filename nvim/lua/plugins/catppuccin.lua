return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            integrations = {
                snacks = true,
                mini = true,
            },
        })
        -- load the colorscheme
        vim.cmd.colorscheme("catppuccin")
    end,
}
