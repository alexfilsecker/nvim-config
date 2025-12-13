return {
  "github/copilot.vim",
  config = function()
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap(
      "i",
      "<S-Tab>",
      'copilot#Accept("<CR>")',
      { expr = true, replace_keycodes = false }
    )
  end
}
