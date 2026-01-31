return {
    {
        "ravitemer/mcphub.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        build = "bundled_build.lua",
        opts = {
            use_bundled_binary = true,
        },
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "ravitemer/codecompanion-history.nvim",
            {
                "hakonharnes/img-clip.nvim",
                opts = {
                    filetypes = {
                        codecompanion = {
                            prompt_for_file_name = false,
                            template = "[Image]($FILE_PATH)",
                            use_absolute_path = true,
                        },
                    },
                },
            },
        },
        opts = {
            interactions = {
                chat = {
                    adapter = "gemini_cli",
                },
            },
            extensions = {
                history = {
                    enabled = true,
                    opts = {
                        expiration_days = 14,
                        picker = "snacks",
                        chat_filter = function(chat_data)
                            return chat_data.cwd == vim.fn.getcwd()
                        end,
                    },
                },
                mcphub = {
                    callback = "mcphub.extensions.codecompanion",
                    opts = {
                        make_tools = true,
                        show_server_tools_in_chat = true,
                        add_mcp_prefix_to_tool_names = false,
                        show_result_in_chat = true,
                        make_vars = true,
                        make_slash_commands = true,
                    },
                },
            },
        },
        keys = {
            {
                "<leader>cc",
                "<cmd>CodeCompanionChat Toggle<CR>",
                mode = { "n", "x" },
                desc = "CodeCompanion: Chat Toggle",
            },
            { "<leader>cn", "<cmd>CodeCompanionChat<CR>", mode = { "n", "x" }, desc = "CodeCompanion: New Chat" },
            { "<leader>ca", "<cmd>CodeCompanionActions<CR>", mode = { "n", "x" }, desc = "CodeCompanion: Actions" },
            { "<leader>ci", "<cmd>CodeCompanion<CR>", mode = { "n", "x" }, desc = "CodeCompanion: Inline" },
        },
    },
}
