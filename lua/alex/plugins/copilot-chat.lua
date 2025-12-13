return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  build = "make tiktoken",
  config = function()
    local copilot_chat = require("CopilotChat")
    copilot_chat.setup({
      mappings = {
        reset = false,
      }
    })

    local map = vim.keymap.set
    map("n", "<leader>cc", "<cmd>CopilotChat<cr>", { desc = "Open Copilot Chat" })
    map("n", "<leader>cr", "<cmd>CopilotChatReset<cr>", { desc = "Copilot reset chat window" })

    vim.keymap.set('n', '<leader>cs', function()
      vim.cmd('CopilotChatSave ' .. vim.fn.input('Save CopilotChat as: '))
    end, { desc = 'Save CopilotChat session with prompt' })
  end

}
