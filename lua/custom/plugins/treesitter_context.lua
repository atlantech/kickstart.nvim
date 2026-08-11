vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-context' }

require('treesitter-context').setup {
  enable = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    return ft ~= 'javascriptreact' and ft ~= 'typescriptreact'
  end,
}
