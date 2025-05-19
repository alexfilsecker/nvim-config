-- Nvim-lspconfig is used to configure your language servers.

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },

  config = function()
    -- import lspconfig plugin
    local lspconfig = require("lspconfig")

    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    local opts = {}
    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp tYpe definitions

      opts.desc = "See available code actions"
      keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

      opts.desc = "Smart rename"
      keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

      opts.desc = "Show buffer diagnostics"
      keymap.set(
        "n",
        "<leader>D",
        "<cmd>Telescope diagnostics bufnr=0<CR>",
        opts
      ) -- show  diagnostics for file

      opts.desc = "Show line diagnostics"
      keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end
    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities =
      vim.tbl_deep_extend("force", cmp_nvim_lsp.default_capabilities(), {
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      })
    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs =
      { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    local normal_setup_lsp = {
      "clangd",
      "eslint",
      "html",
      "prismals",
      "pylsp",
      "tailwindcss",
      "ts_ls",
    }

    for i = 1, #normal_setup_lsp do
      lspconfig[normal_setup_lsp[i]].setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end

    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = function(client, buffer)
        if client.name == "svelte" then
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            group = vim.api.nvim_create_augroup(
              "svelte_ondidchangetsorjsfile",
              { clear = true }
            ),
            callback = function(ctx)
              -- Here use ctx.match instead of ctx.file
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end
        on_attach(client, buffer)
      end,
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        css = {
          lint = {
            unknownAtRules = "ignore",
          },
        },
      },
    })

    -- mason_lspconfig.setup_handlers({
    --   -- default handler for installed servers
    --   function(server_name)
    --     lspconfig[server_name].setup({
    --       capabilities = capabilities,
    --       on_attach = on_attach,
    --     })
    --   end,
    --
    --   ["svelte"] = function()
    --     lspconfig["svelte"].setup({
    --       capabilities = capabilities,
    --       on_attach = function(client, buffer)
    --         if client.name == "svelte" then
    --           vim.api.nvim_create_autocmd("BufWritePost", {
    --             pattern = { "*.js", "*.ts" },
    --             group = vim.api.nvim_create_augroup(
    --               "svelte_ondidchangetsorjsfile",
    --               { clear = true }
    --             ),
    --             callback = function(ctx)
    --               -- Here use ctx.match instead of ctx.file
    --               client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
    --             end,
    --           })
    --         end
    --         on_attach(client, buffer)
    --       end,
    --     })
    --   end,
    --
    --   ["lua_ls"] = function()
    --     -- configure lua server (with special settings)
    --     lspconfig["lua_ls"].setup({
    --       capabilities = capabilities,
    --       on_attach = on_attach,
    --       settings = {
    --         Lua = {
    --           completion = {
    --             callSnippet = "Replace",
    --           },
    --         },
    --       },
    --     })
    --   end,
    --   ["cssls"] = function()
    --     lspconfig["cssls"].setup({
    --       capabilities = capabilities,
    --       on_attach = on_attach,
    --       settings = {
    --         css = {
    --           lint = {
    --             unknownAtRules = "ignore",
    --           },
    --         },
    --       },
    --     })
    --   end,
    -- })
  end,
}
