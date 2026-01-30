return {
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "ravitemer/codecompanion-history.nvim",
            {
                "HakonHarnes/img-clip.nvim",
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
                        continue_last_chat = true,
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
