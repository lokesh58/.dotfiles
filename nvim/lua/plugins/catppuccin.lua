return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            integrations = {
                gitsigns = true,
                mini = true,
                snacks = {
                    enabled = true,
                    indent_scope_color = "surface2",
                },
                treesitter = true,
            },
        })
        -- load the colorscheme
        vim.cmd.colorscheme("catppuccin")
    end,
}
