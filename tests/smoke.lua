local failures = {}

local function check(condition, message)
  if not condition then table.insert(failures, message) end
end

check(vim.startswith(vim.g.colors_name or '', 'catppuccin'), 'catppuccin is not active')
check(vim.g.have_nerd_font == true, 'Nerd Font setting was not preserved')
check(vim.o.relativenumber, 'relative line numbers are disabled')
check(vim.o.tabstop == 4 and vim.o.shiftwidth == 4 and not vim.o.expandtab, 'indentation options were not preserved')

check(vim.fn.maparg('tn', 'n') ~= '', 'tab-next keymap is missing')
check(vim.fn.maparg('<leader>sg', 'n') ~= '', 'live-grep keymap is missing')
check(vim.fn.maparg('<F9>', 'n') ~= '', 'debug breakpoint keymap is missing')

for _, module in ipairs {
  'custom.plugins.completion',
  'custom.plugins.formatting',
  'custom.plugins.lsp',
  'custom.plugins.noice',
  'custom.plugins.telescope',
  'custom.plugins.toggleterm',
  'custom.plugins.treesitter_context',
  'custom.plugins.vim_fugitive',
} do
  check(package.loaded[module] ~= nil, module .. ' was not loaded')
end

check(vim.lsp.is_enabled 'gopls', 'gopls is not enabled')
check(vim.lsp.is_enabled 'ts_ls', 'ts_ls is not enabled')
check(not vim.lsp.is_enabled 'marksman', 'marksman should be disabled')

vim.cmd.edit '/private/tmp/kickstart-smoke.tofu'
check(vim.bo.filetype == 'tofu', 'OpenTofu filetype detection failed')

vim.cmd.edit '/private/tmp/playbooks/kickstart-smoke.yml'
check(vim.bo.filetype == 'yaml.ansible', 'Ansible filetype detection failed')

vim.bo.filetype = 'typescript'
local formatter_names = {}
for _, formatter in ipairs(require('conform').list_formatters(0)) do
  formatter_names[formatter.name] = true
end
check(formatter_names.eslint_d and formatter_names.prettier, 'TypeScript formatter chain is incomplete')

check(vim.fn.exists ':DiffviewOpen' == 2, 'Diffview command is missing')
check(vim.fn.exists ':Neogit' == 2, 'Neogit command is missing')

if #failures > 0 then
  vim.api.nvim_err_writeln(table.concat(failures, '\n'))
  vim.cmd.cquit { args = { '1' } }
end

print 'kickstart migration smoke tests passed'
vim.cmd.qa()
