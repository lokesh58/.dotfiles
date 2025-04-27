return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        {
            "<leader>ff",
            "<cmd>FzfLua files<cr>",
            desc = "Find Files (Project)"
        },
        {
            "<leader>fg",
            "<cmd>FzfLua live_grep<cr>",
            desc = "Find via Grep (Project)"
        },
        {
            "<leader>fr",
            "<cmd>FzfLua resume<cr>",
            desc = "Resume last search in fzf lua"
        },
        {
            "<leader>fh",
            "<cmd>FzfLua helptags<cr>",
            desc = "Find Help tags"
        },
        {
            "<leader><leader>",
            "<cmd>FzfLua buffers<cr>",
            desc = "Find and switch open buffers"
        },
        {
            "<leader>fw",
            "<cmd>FzfLua grep_cword<cr>",
            desc = "Find word under cursor"
        },
        {
            "<leader>fW",
            "<cmd>FzfLua grep_cWORD<cr>",
            desc = "Find WORD under cursor"
        },
        {
            "<leader>fv",
            "<cmd>FzfLua grep_visual<cr>",
            mode = "v",
            desc = "Find visual selection"
        },
        {
            "<leader>f/",
            "<cmd>FzfLua lgrep_curbuf<cr>",
            desc = "Find in current buffer"
        },
        {
            "<leader>fo",
            "<cmd>FzfLua oldfiles<cr>",
            desc = "Find old (recently opened) files"
        },
        {
            "<leader>fb",
            "<cmd>FzfLua builtin<cr>",
            desc = "Find via any Builtin finder"
        },
        {
            "<leader>fm",
            "<cmd>FzfLua marks<cr>",
            desc = "Find Marks"
        }
    }
}
