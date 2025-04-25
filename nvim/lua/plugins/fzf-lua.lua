return {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
    keys = {
        {
            "<leader>ff",
            "<cmd>FzfLua files<cr>",
            desc = "Find Files in CWD"
        },
        {
            "<leader>sg",
            "<cmd>FzfLua live_grep<cr>",
            desc = "Search (grep) in CWD"
        }
    }
}
