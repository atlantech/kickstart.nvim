vim.pack.add {
  'https://github.com/nvim-telescope/telescope-file-browser.nvim',
  'https://github.com/nvim-telescope/telescope-live-grep-args.nvim',
}

local telescope = require 'telescope'
telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        preview_width = 0.7,
        results_width = 0.3,
        height = 0.98,
        preview_height = 0.6,
      },
    },
  },
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
    file_browser = { hijack_netrw = true },
    live_grep_args = {
      auto_quoting = true,
      default_mappings = {},
      mappings = {},
    },
  },
}

pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'ui-select')
pcall(telescope.load_extension, 'file_browser')
pcall(telescope.load_extension, 'live_grep_args')

local builtin = require 'telescope.builtin'
vim.keymap.set(
  'n',
  '<leader>sg',
  function() telescope.extensions.live_grep_args.live_grep_args { additional_args = { '--ignore-case' } } end,
  { desc = '[S]earch by [G]rep' }
)
vim.keymap.set('n', '<leader>sG', builtin.git_status, { desc = '[S]earch [G]it status' })
vim.keymap.set('n', '<leader>fb', function() telescope.extensions.file_browser.file_browser() end, { desc = '[F]ile [B]rowser' })

local function test_last_sorter()
  local sorters = require 'telescope.sorters'
  local fzy = require 'telescope.algos.fzy'
  return sorters.Sorter:new {
    scoring_function = function(_, prompt, _, entry)
      if prompt == '' or not entry.filename then return 0 end
      local display = entry.display and entry:display() or ''
      if not fzy.has_match(prompt, display) then return -1 end
      local score = fzy.score(prompt, display)
      local lower = entry.filename:lower()
      if lower:find 'test' or lower:find 'spec' or lower:find '__tests__' then score = score - 10 end
      return score
    end,
  }
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom-telescope-lsp-attach', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', 'grr', function() builtin.lsp_references { sorter = test_last_sorter() } end, { buffer = event.buf, desc = '[G]oto [R]eferences' })
  end,
})
