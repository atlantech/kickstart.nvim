vim.pack.add { 'https://github.com/stevearc/overseer.nvim' }
require('overseer').setup { dap = false }

require('which-key').add { { '<leader>r', group = '[R]un tasks' } }
vim.keymap.set('n', '<leader>rs', '<cmd>OverseerShell<CR>', { desc = '[R]un [S]hell command' })
vim.keymap.set('n', '<leader>rr', '<cmd>OverseerRun<CR>', { desc = '[R]un task template' })
vim.keymap.set('n', '<leader>rt', '<cmd>OverseerToggle<CR>', { desc = '[R]un: toggle [T]ask list' })
vim.keymap.set('n', '<leader>ra', '<cmd>OverseerTaskAction<CR>', { desc = '[R]un: task [A]ction' })
