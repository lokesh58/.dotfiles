return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)
    vim.keymap.set("n", "<leader>cf", function()
      conform.format({ lsp_format = "fallback" })
    end, { desc = "Format the current buffer" })
  end,
}
