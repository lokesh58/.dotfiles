return {
    {
        "Shatur/neovim-session-manager",
        lazy = false,
        opts = function()
            local config = require("session_manager.config")
            return {
                autoload_mode = config.AutoloadMode.Disabled,
            }
        end,
        keys = {
            { "<leader>qs", "<cmd>SessionManager load_current_dir_session<CR>", desc = "Load session" },
            { "<leader>qS", "<cmd>SessionManager load_session<CR>", desc = "Load session" },
            { "<leader>ql", "<cmd>SessionManager load_last_session<CR>", desc = "Load last session" },
            { "<leader>qD", "<cmd>SessionManager delete_session<CR>", desc = "Delete session" },
        },
    },
}
