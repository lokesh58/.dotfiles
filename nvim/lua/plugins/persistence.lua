return {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
        branch = false,
    },
    config = function(_, opts)
        require("persistence").setup(opts)
        vim.api.nvim_create_autocmd("User", {
            desc = "Close open buffers before loading a session",
            pattern = "PersistenceLoadPre",
            group = vim.api.nvim_create_augroup("persistence-load-pre", { clear = true }),
            callback = function()
                Snacks.bufdelete.all()
            end,
        })
    end,
    keys = {
        {
            "<leader>qs",
            function()
                require("persistence").load()
            end,
            desc = "Load the session for the current directory",
        },
        {
            "<leader>qS",
            function()
                local persistence = require("persistence")
                if persistence.active() then
                    persistence.save()
                end
                persistence.select()
            end,
            desc = "Select a session to load",
        },
        {
            "<leader>ql",
            function()
                require("persistence").load({ last = true })
            end,
            desc = "Load the last session",
        },
        {
            "<leader>qd",
            function()
                require("persistence").stop()
            end,
            desc = "Stop persistence => session won't be saved on exit",
        },
    },
}
