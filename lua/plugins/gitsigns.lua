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
        end, "Next Hunk")

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Previous Hunk")

        -- Hunk actions, under <leader>gh so the whole git surface -- pickers,
        -- log, blame, hunks -- hangs off <leader>g. These used to sit on
        -- <leader>h, which also held the nohlsearch mapping.
        map("n", "<leader>ghs", gitsigns.stage_hunk, "Stage Hunk")
        map("n", "<leader>ghr", gitsigns.reset_hunk, "Reset Hunk")

        map("v", "<leader>ghs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage Selected Hunk")

        map("v", "<leader>ghr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset Selected Hunk")

        map("n", "<leader>ghS", gitsigns.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghR", gitsigns.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gitsigns.preview_hunk, "Preview Hunk")
        map(
          "n",
          "<leader>ghi",
          gitsigns.preview_hunk_inline,
          "Preview Hunk Inline"
        )

        map("n", "<leader>ghd", gitsigns.diffthis, "Diff This")

        map("n", "<leader>ghD", function()
          gitsigns.diffthis("~")
        end, "Diff This (~)")

        -- One quickfix mapping rather than two. The buffer-scoped variant sat
        -- close enough to <leader>xq to not be worth a key of its own.
        map("n", "<leader>ghq", function()
          gitsigns.setqflist("all")
        end, "All Hunks to Quickfix")

        -- Blame reads as a git action rather than a hunk one, so it sits a
        -- level up, next to the git log pickers.
        map("n", "<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame Line")

        -- Toggles live with the other UI toggles. <leader>tb previously shadowed
        -- a global "open terminal on bottom" mapping in every git-tracked file.
        map(
          "n",
          "<leader>uB",
          gitsigns.toggle_current_line_blame,
          "Toggle Line Blame"
        )
        map("n", "<leader>uW", gitsigns.toggle_word_diff, "Toggle Word Diff")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select Hunk")
      end,
    })
  end,
}
