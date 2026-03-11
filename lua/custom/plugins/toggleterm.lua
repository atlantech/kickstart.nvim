local M = {}

M.term_title = function(term)
  local terms = require('toggleterm.terminal').get_all()
  table.sort(terms, function(a, b) return a.id < b.id end)
  local idx = 1
  for i, t in ipairs(terms) do
    if t.id == term.id then idx = i break end
  end
  local name = vim.split(term.name or '', ';')[1]
  return string.format(' [%d/%d] %s ', idx, #terms, name)
end

M.switch_term = function(direction)
  local terms = require('toggleterm.terminal').get_all()
  if #terms < 2 then
    return
  end

  table.sort(terms, function(a, b) return a.id < b.id end)

  local focused_id = require('toggleterm.terminal').get_focused_id()
  if not focused_id then
    return
  end

  local current_idx = nil
  for i, t in ipairs(terms) do
    if t.id == focused_id then
      current_idx = i
      break
    end
  end

  if not current_idx then
    return
  end

  local next_idx
  if direction == 'next' then
    next_idx = current_idx % #terms + 1
  else
    next_idx = (current_idx - 2) % #terms + 1
  end

  local saved = vim.o.eventignore
  vim.o.eventignore = 'WinLeave,BufLeave'
  terms[current_idx]:close()
  terms[next_idx]:open()
  vim.o.eventignore = saved
end

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup({
      open_mapping = [[<c-\>]],
      direction = 'float',
      float_opts = {
        border = 'curved',
        title_pos = 'center',
        width = function() return math.floor(vim.o.columns * 0.85) end,
        height = function() return math.floor(vim.o.lines * 0.85) end,
      },
      on_open = function(term)
        local title = M.term_title(term)
        term.display_name = title
        if term.window and vim.api.nvim_win_is_valid(term.window) then
          vim.api.nvim_win_set_config(term.window, { title = title })
        end
        local opts = { buffer = term.bufnr, silent = true }
        vim.keymap.set('t', '<C-h>', function() M.switch_term('prev') end, opts)
        vim.keymap.set('t', '<C-l>', function() M.switch_term('next') end, opts)
        vim.keymap.set('n', '<C-h>', function() M.switch_term('prev') end, opts)
        vim.keymap.set('n', '<C-l>', function() M.switch_term('next') end, opts)
      end,
    })
  end,
}
