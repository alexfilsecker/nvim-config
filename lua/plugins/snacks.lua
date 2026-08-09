local preview = require("core.preview-buffer")

-- Files opened from these pickers become preview buffers. Unlike the explorer,
-- these sources have no `config` hook, so overriding `confirm` directly works.
local preview_confirm = preview.preview_confirm(function()
  return Snacks.picker.actions.confirm
end)

-- The explorer keeps its own confirm, which the wrapper has to reach through.
local explorer_preview_confirm = preview.preview_confirm(function()
  return require("snacks.explorer.actions").actions.confirm
end)

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = {
      enabled = true,
      filters = {
        exclude = {},
        hidden = false,
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    image = { enabled = true, math = { enabled = false } },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
      sources = {
        diagnostics_buffer = {
          layout = {
            preset = "ivy",
            preview = "main",
          },
        },
        -- The explorer's own `config` hook overwrites `actions.confirm` after
        -- our config is merged, so we register under a new name and point the
        -- confirm keys at it instead. Splits (<C-s>/<C-v>) keep the original
        -- action: opening into a split is deliberate, not a preview.
        explorer = {
          actions = {
            preview_confirm = explorer_preview_confirm,
          },
          win = {
            list = {
              keys = {
                ["<CR>"] = "preview_confirm",
                ["l"] = "preview_confirm",
                ["<2-LeftMouse>"] = "preview_confirm",
              },
            },
            input = {
              keys = {
                ["<CR>"] = { "preview_confirm", mode = { "n", "i" } },
              },
            },
          },
        },
        files = { confirm = preview_confirm },
        git_files = { confirm = preview_confirm },
        -- Same sidebar treatment as the explorer: stays open while you click
        -- through the changed files, each one opening as a preview buffer.
        git_status = {
          confirm = preview_confirm,
          layout = { preset = "sidebar", preview = false },
          focus = "list",
          auto_close = false,
          jump = { close = false },
        },
        recent = { confirm = preview_confirm },
      },
    },
  },
  keys = {
    -- Explorer
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    -- find/file
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent",
    },
    -- Deliberately normal-mode only: in terminal mode <leader> is a literal
    -- space, so binding it there would swallow spaces typed into the shell.
    {
      "<leader>ft",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Terminal",
    },
    -- Most terminals deliver <C-/> as <C-_>, a few send it verbatim. Bind both
    -- so the shortcut works whatever nvim happens to be running inside.
    {
      "<C-/>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Terminal",
      mode = { "n", "t" },
    },
    {
      "<C-_>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "Terminal",
      mode = { "n", "t" },
    },
    -- git
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },
    -- Grep
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Grep Word or Selection",
      mode = { "n", "x" },
    },
    -- search
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
    {
      "<leader>s:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "Icons",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>sr",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    -- lists
    {
      "<leader>xx",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>xX",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>xq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>xl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
    -- ui toggle. The rest of <leader>u is registered in init() below.
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    -- LSP navigation. `gd` is the only one worth owning: Neovim 0.11+ already
    -- maps `grr` references, `gri` implementation, `grt` type definition,
    -- `grn` rename, `gra` code action and `gO` document symbols. Adding our own
    -- on top mostly risks shadowing them -- a `gr` mapping carrying `nowait`
    -- did exactly that, and made rename and code action unreachable.
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    -- code. The rest of <leader>c lives in lua/plugins/nvim-lspconfig.lua.
    -- Call hierarchy has no stock mapping, so it keeps one here.
    {
      "<leader>ci",
      function()
        Snacks.picker.lsp_incoming_calls()
      end,
      desc = "Incoming Calls",
    },
    {
      "<leader>co",
      function()
        Snacks.picker.lsp_outgoing_calls()
      end,
      desc = "Outgoing Calls",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP Workspace Symbols",
    },
    -- Other
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    -- buffer. The rest of <leader>b lives in lua/plugins/bufferline.lua.
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          -- Deliberately shadowing the runtime's vim._print so `:=` renders
          -- through snacks.debug.
          ---@diagnostic disable-next-line: duplicate-set-field
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle
          .option("relativenumber", { name = "Relative Number" })
          :map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option(
            "conceallevel",
            { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }
          )
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle
          .option(
            "background",
            { off = "light", on = "dark", name = "Dark Background" }
          )
          :map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
