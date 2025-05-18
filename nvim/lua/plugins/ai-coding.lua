return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        "yetone/avante.nvim",
        cond = true,
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
            { "zbirenbaum/copilot.lua" }, -- for providers='copilot'
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
        opts = {
            provider = "copilot",
        },
    },
    -- {
    --     "olimorris/codecompanion.nvim",
    --     cond = true,
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --         { "zbirenbaum/copilot.lua" }, -- for providers='copilot'
    --         "ravitemer/codecompanion-history.nvim", -- Save and load conversation history
    --         {
    --             "ravitemer/mcphub.nvim", -- Manage MCP servers
    --             cmd = "MCPHub",
    --             build = "npm install -g mcp-hub@latest",
    --             opts = {},
    --         },
    --         -- {
    --         --     "Davidyz/VectorCode", -- Index and search code in your repositories
    --         --     version = "*",
    --         --     build = "pipx upgrade vectorcode",
    --         --     dependencies = { "nvim-lua/plenary.nvim" },
    --         -- },
    --     },
    --     opts = {
    --         extensions = {
    --             history = {
    --                 enabled = true,
    --                 opts = {
    --                     keymap = "gh",
    --                     auto_generate_title = true,
    --                     continue_last_chat = false,
    --                     delete_on_clearing_chat = false,
    --                     picker = "snacks",
    --                     enable_logging = false,
    --                     dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
    --                 },
    --             },
    --             mcphub = {
    --                 callback = "mcphub.extensions.codecompanion",
    --                 opts = {
    --                     make_vars = true,
    --                     make_slash_commands = true,
    --                     show_result_in_chat = true,
    --                 },
    --             },
    --             -- vectorcode = {
    --             --     opts = {
    --             --         add_tool = true,
    --             --     },
    --             -- },
    --         },
    --     },
    --     config = function(_, opts)
    --         require("codecompanion").setup(opts)
    --         vim.cmd("cab cc CodeCompanion")
    --     end,
    --     keys = {
    --         {
    --             "<leader>cc",
    --             "<cmd>CodeCompanionChat Toggle<CR>",
    --             mode = { "n", "x" },
    --             desc = "Toggle CodeCompanionChat",
    --         },
    --     },
    -- },
}
