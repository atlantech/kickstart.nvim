vim.pack.add { 'https://github.com/onsails/lspkind.nvim' }

require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 0 },
    ghost_text = { enabled = true },
    menu = {
      draw = {
        columns = { { 'kind_icon', gap = 1 }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if ctx.source_name == 'Path' then
                local dev_icon = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then icon = dev_icon end
              else
                icon = require('lspkind').symbolic(ctx.kind, { mode = 'symbol' })
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              if ctx.source_name == 'Path' then
                local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then return dev_hl end
              end
              return ctx.kind_hl
            end,
          },
        },
      },
    },
  },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}
