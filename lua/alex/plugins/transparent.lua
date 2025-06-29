-- This plugin lets me have a transparent background

return {
  "xiyaowong/transparent.nvim",
  config = function()
    local transparent = require("transparent")
    transparent.setup({
      extra_groups = {
        "NvimTreeNormal",
      },
    })

    -- vim.cmd("TransparentEnable")
  end,
}
