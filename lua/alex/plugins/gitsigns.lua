return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, desc)
          local opts = { desc = desc }
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "gitsigns navigate to next hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "gitsigns navigate to prev hunk")

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, "gitsigns stage hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "gitsigns reset hunk")

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "gitsigns stage hunk in visual mode")

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "gitsigns reset hunk in visual mode")

        map(
          "n",
          "<leader>hS",
          gitsigns.stage_buffer,
          "gitsigns stage whole buffer"
        )
        map(
          "n",
          "<leader>hR",
          gitsigns.reset_buffer,
          "gitsigns reset whole buffer"
        )
        map("n", "<leader>hp", gitsigns.preview_hunk, "gitsigns preview hunk")
        map(
          "n",
          "<leader>hi",
          gitsigns.preview_hunk_inline,
          "gitsigns preview hunk inline"
        )

        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "gitsigns blame line with full")

        map("n", "<leader>hd", gitsigns.diffthis, "gitsigns diffthis")

        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, "gitsigns diffthis with ~")

        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, "gitsigns set all q f list")
        map("n", "<leader>hq", gitsigns.setqflist, "gitsigns set q f list")

        -- Toggles
        map(
          "n",
          "<leader>tb",
          gitsigns.toggle_current_line_blame,
          "git signs toogle current line blame"
        )
        map(
          "n",
          "<leader>tw",
          gitsigns.toggle_word_diff,
          "gitsigns toogle word diff"
        )

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "gitsigns select hunk")
      end,
    })
  end,
}
