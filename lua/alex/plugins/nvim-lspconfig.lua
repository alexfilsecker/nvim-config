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

        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "See code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Rename symbol"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Prev diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

        opts.desc = "Next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

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

    -------------------------------------------------------------------------
    -- LSP server list
    -------------------------------------------------------------------------
    local servers = {
      "lua_ls",
      "ts_ls",
      "eslint_d",
      "pyright"
      -- Add more here later: "pyright", "tsserver", etc.
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
