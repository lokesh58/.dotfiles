return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = 'nvim-treesitter.configs',
    opts = {
        ensure_installed = {'lua', 'c', 'cpp', 'cmake', 'make', 'css', 'dockerfile', 'markdown_inline', 'python', 'rust', 'scss', 'tsx', 'typescript', 'yaml', 'javascript', 'html', 'json'},
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<Enter>",
                node_incremental = "<Enter>",
                scope_incremental = false,
                node_decremental = "<Backspace>",
            },
        },
    },
}
