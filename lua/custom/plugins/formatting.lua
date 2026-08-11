require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local enabled_filetypes = {}
    if enabled_filetypes[vim.bo[bufnr].filetype] then return { timeout_ms = 2500 } end
  end,
  default_format_opts = { lsp_format = 'fallback' },
  formatters_by_ft = {
    erlang = { 'erlfmt' },
    go = { 'goimports', 'gofmt' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    css = { 'prettier' },
    html = { 'prettier' },
    python = { 'black' },
    typescript = { 'eslint_d', 'prettier' },
    typescriptreact = { 'eslint_d', 'prettier' },
    javascript = { 'eslint_d', 'prettier' },
    javascriptreact = { 'eslint_d', 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    sql = { 'sleek' },
    dart = { 'dart' },
  },
  formatters = {
    eslint_d = {
      command = 'eslint_d',
      args = { '--stdin', '--stdin-filename', '$FILENAME', '--fix-to-stdout' },
      stdin = true,
      cwd = function(ctx)
        local root_file = vim.fs.find({ 'eslint.config.cjs', 'package.json' }, { upward = true, path = ctx.filename })[1]
        return root_file and vim.fs.dirname(root_file) or nil
      end,
    },
    prettier = {
      command = 'prettier',
      args = { '--stdin-filepath', '$FILENAME' },
      stdin = true,
    },
  },
}
