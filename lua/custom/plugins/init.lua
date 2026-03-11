-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'nvim-treesitter/nvim-treesitter-context',
  opts = {
    enable = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      return ft ~= 'javascriptreact' and ft ~= 'typescriptreact'
    end,
  },
}
