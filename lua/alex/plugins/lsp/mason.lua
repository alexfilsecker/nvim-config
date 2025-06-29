-- Mason.nvim is used to install and manage all of the language servers
-- that you need for the languages you work for.

return {
  "williamboman/mason.nvim",

  config = function()
    -- import mason
    local mason = require("mason")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end,
}
