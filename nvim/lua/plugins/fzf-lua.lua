return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function(_, opts)
        local fzf = require("fzf-lua")
        fzf.setup(opts)
        fzf.register_ui_select()
    end,
    keys = {
        {
            "<leader>ff",
            function()
                FzfLua.files()
            end,
            desc = "Find Files",
        },
        {
            "<leader>fo",
            function()
                FzfLua.oldfiles()
            end,
            desc = "Find Recent (Old) Files",
        },
        {
            "<leader>fc",
            function()
                FzfLua.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "Find in Config",
        },
        -- {
        --     "<leader>fp",
        --     function()
        --         FzfLua.projects()
        --     end,
        --     desc = "Find Projects",
        -- },
        {
            "<leader>fg",
            function()
                FzfLua.live_grep()
            end,
            desc = "Grep",
        },
        {
            "<leader>fw",
            function()
                FzfLua.grep_cword()
            end,
            desc = "Grep word",
        },
        {
            "<leader>fW",
            function()
                FzfLua.grep_cWORD()
            end,
            desc = "Grep WORD",
        },
        {
            "<leader>fv",
            function()
                FzfLua.grep_visual()
            end,
            desc = "Grep visual selection",
            mode = "x",
        },
        {
            "<leader>/",
            function()
                FzfLua.lgrep_curbuf()
            end,
            desc = "Grep current Buffer",
        },
        {
            "<leader><leader>",
            function()
                FzfLua.buffers()
            end,
            desc = "Search open Buffers",
        },
        {
            "<leader>fh",
            function()
                FzfLua.helptags()
            end,
            desc = "Search Help",
        },
        {
            "<leader>fm",
            function()
                FzfLua.marks()
            end,
            desc = "Marks",
        },
        {
            "<leader>fr",
            function()
                FzfLua.resume()
            end,
            desc = "Resume last search",
        },
        {
            "<leader>fa",
            function()
                FzfLua.builtin()
            end,
            desc = "All Picker",
        },
    },
}
