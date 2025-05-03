return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "diff",
            "html",
            "regex",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "query",
            "vim",
            "vimdoc",
        },
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
