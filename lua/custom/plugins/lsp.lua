local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('gdscript', { capabilities = capabilities })
vim.lsp.enable 'gdscript'

local function root_pattern(patterns)
  return function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, patterns)
    if root then on_dir(root) end
  end
end

local vue_language_server_path = vim.fn.stdpath 'data' .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

---@type table<string, vim.lsp.Config>
local servers = {
  clangd = {},
  gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_dir = root_pattern { 'go.work', 'go.mod', '.git' },
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = { unhandledErrors = true, unusedparams = true },
        staticcheck = true,
      },
    },
  },
  pyright = {},
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        imports = { granularity = { group = 'module' }, prefix = 'self' },
        cargo = { buildScripts = { enable = true } },
        procMacro = { enable = true },
      },
    },
  },
  tailwindcss = {
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'html' },
  },
  elixirls = {},
  erlangls = {},
  bashls = {},
  dockerls = {},
  terraformls = {
    filetypes = { 'terraform', 'tf', 'terraform-vars', 'tofu' },
  },
  ansiblels = {
    filetypes = { 'yaml.ansible' },
    settings = {
      ansible = {
        ansible = { path = 'ansible' },
        python = { interpreterPath = 'python3' },
        executionEnvironment = { enabled = false },
      },
    },
  },
  ts_ls = {
    init_options = { plugins = { vue_plugin } },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
    root_dir = root_pattern { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  },
  vue_ls = {},
}

local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, { 'stylua', 'vue-language-server' })
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

vim.lsp.enable('marksman', false)
for name, config in pairs(servers) do
  config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
  vim.lsp.config(name, config)
  vim.lsp.enable(name)
end
