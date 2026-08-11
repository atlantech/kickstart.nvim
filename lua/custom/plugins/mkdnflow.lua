vim.pack.add { 'https://github.com/jakewvincent/mkdnflow.nvim' }

require('mkdnflow').setup {
  modules = {
    links = true,
    cursor = true,
  },
  links = {
    conceal = false,
    context = 0,
    implicit_extension = nil,
  },
  mappings = {
    MkdnEnter = { { 'n', 'v' }, '<CR>' },
    MkdnTab = false,
    MkdnSTab = false,
    MkdnNextLink = { 'n', '<Tab>' },
    MkdnPrevLink = { 'n', '<S-Tab>' },
    MkdnNextHeading = { 'n', ']h' },
    MkdnPrevHeading = { 'n', '[h' },
  },
}
