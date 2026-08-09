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

        opts.desc = "Line Diagnostics"
        keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

        -- Aliases for the stock `grn` and `gra`, which keep working. These
        -- exist so the two actions you reach for most appear in the which-key
        -- tree beside the rest of <leader>c, instead of living only on a
        -- g-prefix you have to know about in advance.
        opts.desc = "Rename Symbol"
        keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

        opts.desc = "Code Action"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        -- No `K` here. lua/plugins/ufo.lua maps it globally to peek a folded
        -- region and falls back to `vim.lsp.buf.hover` when the cursor isn't on
        -- a fold, so it is a superset of this. A buffer-local mapping would win
        -- over it on every LSP buffer and lose the fold peek.

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>cR", ":LspRestart<CR>", opts)

        -- Deliberately broader than the one that runs on save. That one is
        -- eslint-only, because ts_ls charges a flat ~500ms per save to answer
        -- `source.fixAll`. This is the opt-in to paying it: every attached
        -- client, ts_ls included. Async is fine here -- there's no write
        -- racing the response the way there is in BufWritePre.
        opts.desc = "Apply source.fixAll (all clients, incl. slow ts_ls)"
        keymap.set("n", "<leader>cx", function()
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.fixAll" }, diagnostics = {} },
          })
        end, opts)
      end,
    })

    -- `source.fixAll` on save lives in lua/core/lsp-fix-all.lua and is driven
    -- from conform.nvim's BufWritePre, so the eslint/prettier order is fixed
    -- in one place instead of falling out of lazy.nvim's load order.

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
    -- Shared with lua/plugins/mason.lua, which installs them.
    local servers = require("core.lsp-servers")

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

    -- Override gopls to exclude gotmpl (not used)
    vim.lsp.config("gopls", {
      filetypes = { "go", "gomod", "gowork" },
    })
  end,
}
