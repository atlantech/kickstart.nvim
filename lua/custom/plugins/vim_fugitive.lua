vim.pack.add {
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
}

require('diffview').setup {}
require('neogit').setup {}

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '[G]it [D]iffview' })
vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewFileHistory %<cr>', { desc = '[G]it [D]iffview (current file)' })
vim.keymap.set('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Neogit' })
vim.keymap.set('n', '<leader>gf', '<cmd>Neogit kind=split<cr>', { desc = 'Neogit (split)' })
