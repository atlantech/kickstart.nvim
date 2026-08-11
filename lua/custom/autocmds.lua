vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.tofu',
  desc = 'Set filetype for OpenTofu files',
  callback = function() vim.bo.filetype = 'tofu' end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    '*/playbooks/*.yml',
    '*/playbooks/*.yaml',
    '*/roles/*/tasks/*.yml',
    '*/roles/*/tasks/*.yaml',
    '*/roles/*/handlers/*.yml',
    '*/roles/*/handlers/*.yaml',
  },
  desc = 'Set filetype for Ansible files',
  callback = function() vim.bo.filetype = 'yaml.ansible' end,
})
