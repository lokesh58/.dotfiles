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
            -- {
            --     "zbirenbaum/copilot.lua", -- for providers='copilot'
            --     cmd = "Copilot",
            --     event = "InsertEnter",
            --     opts = {
            --         suggestion = { enabled = false },
            --         panel = { enabled = false },
            --     },
            -- },
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
            provider = "claude",
        },
    },
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        opts = {},
        keys = {
            { "<leader>cc", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude" },
            { "<leader>cf", "<cmd>ClaudeCodeFocus<CR>", desc = "Focus Claude" },
            { "<leader>cr", "<cmd>ClaudeCode --resume<CR>", desc = "Resume Claude" },
            { "<leader>cC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue Claude" },
            { "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>", desc = "Add current buffer" },
            { "<leader>cs", "<cmd>ClaudeCodeSend<CR>", mode = "x", desc = "Send to Claude" },
            {
                "<leader>cs",
                "<cmd>ClaudeCodeTreeAdd<CR>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil" },
            },
            -- Diff management
            { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
            { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", desc = "Deny diff" },
        },
    },
}
