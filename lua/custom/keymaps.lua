vim.keymap.set('n', '<C-h>', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<C-l>', '<cmd>tabnext<CR>', { desc = 'Next tab' })

vim.keymap.set('n', 'tn', '<cmd>tabnext<CR>', { desc = '[T]ab [N]ext' })
vim.keymap.set('n', 'tp', '<cmd>tabprevious<CR>', { desc = '[T]ab [P]revious' })
vim.keymap.set('n', 'tc', '<cmd>tabclose<CR>', { desc = '[T]ab [C]lose' })
vim.keymap.set('n', 'to', '<cmd>tabnew<CR>', { desc = '[T]ab [O]pen (new)' })

vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
vim.keymap.set('n', '<leader>bw', '<cmd>bwipeout<CR>', { desc = '[B]uffer [W]ipeout' })
