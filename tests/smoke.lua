local failures = {}

local function check(condition, message)
  if not condition then table.insert(failures, message) end
end

check(vim.startswith(vim.g.colors_name or '', 'catppuccin'), 'catppuccin is not active')
check(vim.g.have_nerd_font == true, 'Nerd Font setting was not preserved')
check(vim.o.relativenumber, 'relative line numbers are disabled')
check(vim.o.tabstop == 4 and vim.o.shiftwidth == 4 and not vim.o.expandtab, 'indentation options were not preserved')

check(vim.fn.maparg('tn', 'n') ~= '', 'tab-next keymap is missing')
check(vim.fn.maparg('<leader>tt', 'n') ~= '', 'terminal-tab keymap is missing')
check(vim.fn.maparg('<leader>sg', 'n') ~= '', 'live-grep keymap is missing')
check(vim.fn.maparg('<leader>gv', 'n') ~= '', 'Git vertical-diff keymap is missing')
check(vim.fn.maparg('<F9>', 'n') ~= '', 'debug breakpoint keymap is missing')

local completion_keymap = require('blink.cmp.config').keymap
check(completion_keymap['<C-l>'] ~= nil, 'completion trigger keymap is missing')
check(completion_keymap['<C-space>'] == false, 'conflicting Ctrl-Space completion keymap is still active')

local telescope_sorters = require 'custom.telescope_sorters'
check(telescope_sorters.is_test_file { filename = 'internal/service_test.go' }, 'Go test file was not detected')
check(not telescope_sorters.is_test_file { filename = 'internal/latest/service.go' }, 'production file was misclassified as a test')

local reference_sorter = telescope_sorters.test_last()
local production_entry = { filename = 'internal/service.go' }
local test_entry = { filename = 'internal/service_test.go' }
local function reference_score(prompt, entry)
  reference_sorter:_start(prompt)
  local score = reference_sorter:scoring_function(prompt, entry.filename, entry)
  reference_sorter:_finish(prompt)
  return score
end

reference_sorter:_init()
local initial_production_score = reference_score('', production_entry)
local initial_test_score = reference_score('', test_entry)
local production_score = reference_score('service', production_entry)
local test_score = reference_score('service', test_entry)
local unmatched_score = reference_score('no-match', production_entry)
reference_sorter:_destroy()
check(initial_test_score > initial_production_score, 'test references are not initially ranked after production references')
check(production_score ~= -1 and test_score ~= -1, 'matching references were filtered out')
check(test_score > production_score, 'test references are not ranked after production references')
check(unmatched_score == -1, 'unmatched references are not filtered')

for _, module in ipairs {
  'custom.plugins.completion',
  'custom.plugins.formatting',
  'custom.plugins.lsp',
  'custom.plugins.noice',
  'custom.plugins.telescope',
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
