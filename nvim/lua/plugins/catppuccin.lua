return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            integrations = {
                blink_cmp = true,
                flash = true,
                gitsigns = true,
                mini = true,
                native_lsp = {
                    enabled = true,
                    underlines = {
                        errors = { "undercurl" },
                        hints = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                    },
                },
                noice = true,
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
