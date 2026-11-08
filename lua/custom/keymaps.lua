vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>tt', function()
  vim.cmd.tabnew()
  vim.cmd.terminal()
  vim.cmd.startinsert()
end, { desc = 'Open terminal in new tab' })

vim.keymap.set('n', '<leader>st', function()
  local current = vim.api.nvim_get_current_tabpage()
  local items = {}
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local buf = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
    local name = vim.api.nvim_buf_get_name(buf)
    local label
    if vim.bo[buf].buftype == 'terminal' then
      local title = vim.b[buf].term_title
      label = 'terminal: ' .. (title and title ~= '' and title or vim.fn.fnamemodify(vim.o.shell, ':t'))
    else
      label = name ~= '' and vim.fn.fnamemodify(name, ':t') or '[No Name]'
    end
    local extra_windows = #vim.api.nvim_tabpage_list_wins(tab) - 1
    if extra_windows > 0 then label = label .. string.format(' (+%d %s)', extra_windows, extra_windows == 1 and 'window' or 'windows') end
    label = string.format('%d  %s%s', vim.api.nvim_tabpage_get_number(tab), label, tab == current and ' [current]' or '')
    items[#items + 1] = { tab = tab, label = label }
  end
  vim.ui.select(items, {
    prompt = 'Tabs',
    format_item = function(item) return item.label end,
  }, function(item)
    if item and vim.api.nvim_tabpage_is_valid(item.tab) then vim.api.nvim_set_current_tabpage(item.tab) end
  end)
end, { desc = '[S]earch [T]abs' })

vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bw', '<cmd>bwipeout<CR>', { desc = '[B]uffer [W]ipeout' })
