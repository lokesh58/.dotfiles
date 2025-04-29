return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
        highlight = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Enter>",
                node_incremental = "<Enter>",
                scope_incremental = false,
                node_decremental = "<Backspace>",
            },
        },
        indent = { enable = true },
    },
}
