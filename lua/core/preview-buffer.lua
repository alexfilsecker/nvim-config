-- VS Code style "preview buffers".
--
-- Files opened from the snacks explorer or a file picker are transient: opening
-- another file closes the previous one, so at most one preview buffer exists.
-- Editing or pinning a buffer promotes it to a permanent one.

local M = {}

-- The buffer currently in preview state. `vim.b[buf].preview_buffer` is the
-- source of truth, this is just a handle so we don't scan every buffer.
local preview_buf = nil

-- Promote a buffer out of preview state, making it permanent.
function M.promote(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_valid(buf) then
    vim.b[buf].preview_buffer = nil
  end
  if preview_buf == buf then
    preview_buf = nil
  end
end

-- Close the tracked preview buffer, unless anything suggests we shouldn't.
local function close_preview(except)
  local buf = preview_buf

  -- Reopening the file that's already the preview leaves it as the preview.
  if not buf or buf == except then
    return
  end
  preview_buf = nil

  if
    not vim.api.nvim_buf_is_valid(buf)
    -- promoted since we last saw it
    or not vim.b[buf].preview_buffer
    -- never discard unsaved work. This also keeps `Snacks.bufdelete` from
    -- popping its save-changes confirmation.
    or vim.bo[buf].modified
    -- still on screen somewhere, e.g. the user split it off
    or #vim.fn.win_findbuf(buf) > 0
  then
    -- Kept it, so it's permanent now: don't leave a preview flag behind on a
    -- buffer we've stopped tracking.
    if vim.api.nvim_buf_is_valid(buf) then
      vim.b[buf].preview_buffer = nil
    end
    return
  end

  Snacks.bufdelete(buf)
end

local function mark_preview(buf)
  vim.b[buf].preview_buffer = true
  preview_buf = buf
end

-- Wrap a picker confirm action so the file it opens becomes a preview buffer.
function M.confirm_wrapper(orig)
  return function(picker, item, action)
    -- Nothing to preview: no item, a directory toggle, or the explorer's
    -- search mode, which only moves the cursor.
    if not item or item.dir or (picker.input.filter.meta or {}).searching then
      return orig(picker, item, action)
    end

    -- Splitting is deliberate placement, not a preview. The split actions are
    -- defined as `{ action = "confirm", cmd = "split" }`, so overriding a
    -- source's `confirm` catches <C-s>/<C-v>/<C-t> as well. A plain confirm
    -- carries no `cmd`, which is what separates the two.
    if action and action.cmd then
      return orig(picker, item, action)
    end

    -- Track what `Snacks.picker.actions.jump` really opens. It ignores the item
    -- under the cursor and works off `picker:selected({ fallback = true })`;
    -- the two only coincide while nothing is <Tab>-selected. A multi-select
    -- opens every file at once, leaving no single buffer to preview, so treat a
    -- deliberate batch the way splits are treated: all permanent.
    local selected = picker:selected({ fallback = true })
    if #selected ~= 1 then
      return orig(picker, item, action)
    end

    -- Resolve the buffer exactly the way `Snacks.picker.actions.jump` does:
    -- `item.buf` first, `bufadd(path)` only as a fallback. Going straight to
    -- `bufadd(path)` is not a lookup -- it *creates* a buffer when nothing
    -- matches the name, so for any item carrying `item.buf`, or any path that
    -- normalizes differently from the buffer's stored name (a symlinked cwd,
    -- /tmp vs /private/tmp on macOS), we'd track a phantom while the file the
    -- user actually opened went untracked. We can't read the current window
    -- instead: the explorer keeps focus in its list.
    local buf = selected[1].buf
    if not buf then
      local path = Snacks.picker.util.path(selected[1])
      if not path then
        return orig(picker, item, action)
      end
      buf = vim.fn.bufadd(path)
    end
    if buf == 0 or not vim.api.nvim_buf_is_valid(buf) then
      return orig(picker, item, action)
    end

    -- A file that was already open stays permanent, like VS Code.
    local existed = vim.api.nvim_buf_is_loaded(buf)

    orig(picker, item, action)

    -- `Snacks.picker.actions.jump` reschedules itself when called from insert
    -- mode, so the jump may not have happened yet.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then
        return
      end

      close_preview(buf)

      if not existed then
        mark_preview(buf)
      end
    end)
  end
end

-- Build a picker `confirm` action that turns whatever it opens into a preview
-- buffer. `get_orig` is resolved on first keypress rather than now, because the
-- explorer only installs its own `confirm` once snacks has loaded, then
-- memoized so repeated presses don't each build a closure.
function M.preview_confirm(get_orig)
  local cached_orig, wrapped

  return function(...)
    local orig = get_orig()
    if orig ~= cached_orig then
      cached_orig, wrapped = orig, M.confirm_wrapper(orig)
    end
    return wrapped(...)
  end
end

local group = vim.api.nvim_create_augroup("PreviewBuffer", { clear = true })

-- Any edit promotes the buffer. InsertEnter covers typing, BufModifiedSet
-- covers normal mode edits like `dd`/`p`/`u` and LSP code actions.
vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = function(args)
    if vim.b[args.buf].preview_buffer then
      M.promote(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd("BufModifiedSet", {
  group = group,
  callback = function(args)
    if vim.b[args.buf].preview_buffer and vim.bo[args.buf].modified then
      M.promote(args.buf)
    end
  end,
})

-- Don't hold on to a handle for a buffer that's already gone.
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  group = group,
  callback = function(args)
    if preview_buf == args.buf then
      preview_buf = nil
    end
  end,
})

return M
