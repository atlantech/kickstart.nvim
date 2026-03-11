return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    lsp = {
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      progress = {
        enabled = true,
        format = 'lsp_progress',
        format_done = 'lsp_progress_done',
        throttle = 1000 / 30,
        view = 'mini',
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
        view = nil,
        opts = {},
      },
      hover = {
        enabled = true,
        silent = false,
        view = nil,
        opts = {},
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = true,
    },
    cmdline = {
      enabled = true,
      view = 'cmdline_popup',
      opts = {},
      format = {
        cmdline = { pattern = '^:', icon = ' ', lang = 'vim' },
        search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
        search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
        filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
        lua = { pattern = '^:%s*lua%s+', icon = ' ', lang = 'lua' },
        help = { pattern = '^:%s*he?l?p?%s+', icon = ' ' },
        input = {},
      },
    },
    messages = {
      enabled = true,
      view = 'notify',
      view_error = 'notify',
      view_warn = 'notify',
      view_history = 'messages',
      view_search = 'virtualtext',
    },
    popupmenu = {
      enabled = true,
      backend = 'nui',
      kind_icons = {},
    },
    redirect = {
      view = 'popup',
      filter = { event = 'msg_show' },
    },
    commands = {
      history = {
        view = 'split',
        opts = { enter = true, format = 'details' },
        filter = {
          any = {
            { event = 'notify' },
            { error = true },
            { warning = true },
            { event = 'msg_show', kind = { '' } },
            { event = 'lsp', kind = 'message' },
          },
        },
      },
      last = {
        view = 'popup',
        opts = { enter = true, format = 'text' },
        filter = {
          event = 'msg_show',
          kind = { '' },
        },
        filter_opts = { count = 1 },
      },
      errors = {
        view = 'popup',
        opts = { enter = true, format = 'text' },
        filter = { error = true },
        filter_opts = { count = 1 },
      },
    },
    notify = {
      enabled = true,
      view = 'notify',
    },
    views = {
      cmdline_popup = {
        position = {
          row = 5,
          col = '50%',
        },
        size = {
          width = 60,
          height = 'auto',
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        filter_options = {},
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
      popupmenu = {
        relative = 'editor',
        position = {
          row = 8,
          col = '50%',
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = 'rounded',
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = 'Normal', FloatBorder = 'FloatBorder' },
        },
      },
      split = {
        enter = true,
        relative = 'editor',
        position = 'bottom',
        size = '20%',
        win_options = {
          winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
        },
      },
      mini = {
        backend = 'mini',
        align = 'message-right',
        timeout = 2000,
        reverse = true,
        win_options = {
          winblend = 0,
        },
      },
    },
    routes = {
      {
        filter = {
          event = 'msg_show',
          find = '%d+L, %d+B',
        },
        view = 'mini',
      },
      {
        filter = {
          event = 'msg_show',
          kind = 'search_count',
        },
        view = 'mini',
      },
      {
        filter = {
          event = 'lsp',
          kind = 'progress',
          cond = function(msg)
            local title = vim.tbl_get(msg.opts, 'progress', 'title')
            return title == 'Diagnosing'
          end,
        },
        opts = { skip = true },
      },
    },
    format = {
      level = {
        icons = {
          error = ' ',
          warn = ' ',
          info = ' ',
        },
      },
    },
    health = {
      checker = true,
    },
    smart_move = {
      enabled = true,
      excluded_filetypes = { 'cmp_menu', 'cmp_docs', 'notify' },
    },
  },
  keys = {
    {
      '<S-Enter>',
      function()
        require('noice').redirect(vim.fn.getcmdline())
      end,
      mode = 'c',
      desc = 'Redirect Cmdline',
    },
    {
      '<leader>snl',
      function()
        require('noice').cmd('last')
      end,
      desc = '[S]earch [N]oice [L]ast Message',
    },
    {
      '<leader>snh',
      function()
        require('noice').cmd('history')
      end,
      desc = '[S]earch [N]oice [H]istory',
    },
    {
      '<leader>sna',
      function()
        require('noice').cmd('all')
      end,
      desc = '[S]earch [N]oice [A]ll',
    },
    {
      '<leader>snd',
      function()
        require('noice').cmd('dismiss')
      end,
      desc = '[S]earch [N]oice [D]ismiss All',
    },
    {
      '<c-f>',
      function()
        if not require('noice.lsp').scroll(4) then
          return '<c-f>'
        end
      end,
      silent = true,
      expr = true,
      desc = 'Scroll forward',
    },
    {
      '<c-b>',
      function()
        if not require('noice.lsp').scroll(-4) then
          return '<c-b>'
        end
      end,
      silent = true,
      expr = true,
      desc = 'Scroll backward',
    },
  },
  config = function(_, opts)
    require('noice').setup(opts)
    vim.notify = require('notify')
  end,
}
