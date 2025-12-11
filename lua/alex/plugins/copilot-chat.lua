return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      local copilot_chat = require("CopilotChat")
      copilot_chat.setup()
    end
  },
}
