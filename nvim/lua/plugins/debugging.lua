return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")

            dapui.setup()

            vim.fn.sign_define(
                "DapBreakpoint",
                { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
            )
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "NonText", linehl = "", numhl = "" })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "Toggle Debug Breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue Debug" })
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
        opts = {
            ensure_installed = {}, -- installing using mason-tool-installer
            handlers = {},
        },
    },
}
