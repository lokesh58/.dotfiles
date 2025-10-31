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
            behaviour = {
                auto_approve_tool_permissions = false,
                confirmation_ui_style = "popup",
            },
        },
    },
}
