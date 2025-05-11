return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
        {
            "ravitemer/mcphub.nvim", -- Manage MCP servers
            cmd = "MCPHub",
            build = "npm install -g mcp-hub@latest",
            config = true,
        },
        {
            "Davidyz/VectorCode", -- Index and search code in your repositories
            version = "*",
            build = "pipx upgrade vectorcode",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
    },
    opts = {
        extensions = {
            history = {
                enabled = true,
                opts = {
                    keymap = "gh",
                    auto_generate_title = true,
                    continue_last_chat = false,
                    delete_on_clearing_chat = false,
                    picker = "snacks",
                    enable_logging = false,
                    dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
                },
            },
            mcphub = {
                callback = "mcphub.extensions.codecompanion",
                opts = {
                    make_vars = true,
                    make_slash_commands = true,
                    show_result_in_chat = true,
                },
            },
            vectorcode = {
                opts = {
                    add_tool = true,
                },
            },
        },
    },
}
