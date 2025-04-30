return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
        { "<leader>qs", function() require("persistence").load() end, desc = "Load the session for the current directory" }, 
        { "<leader>qS", function() require("persistence").select() end, desc = "Select a session to load" }, 
        { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Load the last session" }, 
        { "<leader>qd", function() require("persistence").stop() end, desc = "Stop persistence => session won't be saved on exit" }, 
    },
}
