return {
  'tpope/vim-fugitive',
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iffview' },
      { '<leader>gD', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it [D]iffview (current file)' },
    },
    opts = {},
  },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Neogit' },
      { '<leader>gf', '<cmd>Neogit kind=split<cr>', desc = 'Neogit (split)' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {},
  },
}
