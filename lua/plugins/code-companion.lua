return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ravitemer/mcphub.nvim",
  },
  config = function()
    local codecompanion = require("codecompanion")
    codecompanion.setup({
      debug = true,
      adapters = {
        gemini_cli = function()
          return require("codecompanion.adapters").extend("gemini_cli", {
            defaults = {
              auth_method = "oauth-personal", -- "oauth-personal"|"gemini-api-key"|"vertex-ai"
            },
          })
        end,
      },
      interactions = {
        chat = {
          adapter = "gemini_cli",
        },
        inline = {
          adapter = "gemini_cli",
        },
        cmd = {
          adapter = "gemini_cli",
        },
        background = {
          adapter = "gemini_cli",
        },
      },
    })

    local keymap = vim.keymap.set

    keymap("n", "<leader>cc", ":CodeCompanionChat<CR>", { desc = "Code Companion Chat" })
  end,
}
