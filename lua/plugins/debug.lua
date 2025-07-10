return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        'debugpy',
        'black',
        'mypy',
        'ruff-lsp',
        'pyright',
        'clangd',
        'clang-format',
        'codelldb',
        'cssls',
        'html-lsp',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
    vim.keymap.set('n', '<F8>', dapui.close, { desc = 'Debug: Close UI' })

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    -- dap.listeners.before.event_terminated['dapui_config'] = function(session)
    -- if session.config.type ~= 'codelldb' or session.config.type ~= 'python' then
    -- dapui.close()
    -- end
    -- end

    -- dap.listeners.before.event_exited['dapui_config'] = function(session)
    -- if session.config.type ~= 'codelldb' or session.config.type ~= 'python' then
    -- dapui.close()
    -- end
    -- end
    dap.listeners.before.event_terminated['dapui_config'] = nil
    -- dapui.close()
    -- end
    dap.listeners.before.event_exited['dapui_config'] = nil
    -- dapui.close()
    -- end
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb',
        args = { '--port', '${port}' },
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch executable (C/C++)',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/main', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/packages/codelldb/extension/adapter/codelldb',
        args = { '--port', '${port}' },
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch executable (C/C++)',
        type = 'codelldb',
        request = 'launch',
        cwd = '${workspaceFolder}',
        program = function()
          local file = vim.fn.expand '%:p'
          local exe = vim.fn.expand '%:p:r'
          -- Compile the file before launching
          vim.fn.jobstart("g++ '" .. file .. "' -g -o '" .. exe .. "'", {
            on_exit = function(_, code)
              if code ~= 0 then
                vim.notify('❌ Compile failed!', vim.log.levels.ERROR)
              end
            end,
          })
          return exe
        end,
        stopOnEntry = false,
        args = {},
      },
    }

    dap.configurations.c = dap.configurations.cpp

    -- dap.configurations.c = dap.configurations.cpp
    -- Install golang specific config
    -- require('dap-go').setup()
    local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
    require('dap-python').setup(path)
  end,
}
