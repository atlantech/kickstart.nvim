vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.tofu',
  desc = 'Set filetype for OpenTofu files',
  callback = function() vim.bo.filetype = 'tofu' end,
})

vim.api.nvim_create_autocmd('CursorHold', {
  group = vim.api.nvim_create_augroup('custom-go-checktime', { clear = true }),
  pattern = { '*.go', 'go.mod', 'go.work' },
  desc = 'Check the current Go buffer for external edits',
  nested = true,
  callback = function(event)
    local opts = vim.bo[event.buf]
    if opts.buftype == '' and not opts.modified then vim.cmd.checktime { count = event.buf } end
  end,
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
