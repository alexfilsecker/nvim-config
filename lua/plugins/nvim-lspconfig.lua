return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },

  config = function()
    -- LSP keymaps: use LspAttach instead of on_attach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local bufnr = event.buf
        local keymap = vim.keymap
        local opts = { buffer = bufnr }

        opts.desc = "Line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Hover"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
      end
    })

    -------------------------------------------------------------------------
    -- Capabilities (for completion)
    -------------------------------------------------------------------------
    local cmp = require("cmp_nvim_lsp")
    local capabilities = cmp.default_capabilities()

    -- Add folding range capability
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -------------------------------------------------------------------------
    -- LSP server list
    -------------------------------------------------------------------------
    local servers = {
      "lua_ls",
      "ts_ls",
      "eslint_d",
      "pyright",
      "gopls",
    }

    -------------------------------------------------------------------------
    -- Configure + enable each server
    -------------------------------------------------------------------------
    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
        -- You CAN put per-server settings here
        -- but global keymaps use LspAttach now.
      })

      vim.lsp.enable(server)
    end
  end
}
