return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    -- All of this complex config is just to change the
    -- blend value for comments from 0.4 to 0.5
    -- because I am too blind to see them otherwise


    local C = require("nightfox.lib.color")
    local carbonfox_og_return = require("nightfox.palette.carbonfox")
    local og_palette = carbonfox_og_return.palette
    local og_fg_str = og_palette.fg1
    local og_bg_str = og_palette.bg1
    local og_fg = C(og_fg_str)
    local og_bg = C(og_bg_str)
    local new_comment_str = og_bg:blend(og_fg, 0.5):to_css()


    -- here is a comment to see how it looks
    local not_used_var


    local nightfox = require("nightfox")
    nightfox.setup({
      palettes = {
        carbonfox = {
          comment = new_comment_str
        }
      }
    })

    vim.cmd("colorscheme carbonfox")
  end
}
