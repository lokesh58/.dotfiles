return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        build = (function()
            if vim.fn.has("win32") == 1 then
                return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            end
            return "make"
        end)(),
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "folke/snacks.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
        },
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            provider = "gemini-cli",
            acp_providers = {
                ["gemini-cli"] = {
                    command = "gemini",
                    args = { "--experimental-acp" },
                    auth_method = "oauth-personal",
                },
            },
            behaviour = {
                auto_approve_tool_permissions = false,
                confirmation_ui_style = "popup",
            },
            selector = {
                provider = "snacks",
            },
            input = {
                provider = "snacks",
            },
        },
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
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
            adapters = {
                acp = {
                    gemini_cli = function()
                        return require("codecompanion.adapters").extend("gemini_cli", {
                            defaults = {
                                auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
                            },
                        })
                    end,
                },
            },
            strategies = {
                chat = {
                    adapter = "gemini_cli",
                },
                agent = {
                    adapter = "gemini_cli",
                },
                -- inline = {
                --     adapter = "copilot",
                -- },
                -- cmd = {
                --     adapter = "deepseek",
                -- },
            },
        },
        keys = {
            { "<leader>cc", "<cmd>CodeCompanionChat<CR>", mode = { "n", "x" }, desc = "CodeCompanion: Chat" },
            { "<leader>ct", "<cmd>CodeCompanionChat Toggle<CR>", mode = { "n", "x" }, desc = "CodeCompanion: Chat" },
        },
    },
}
