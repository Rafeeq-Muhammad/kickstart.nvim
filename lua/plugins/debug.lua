return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = {
    -- ------------------------------------------------------------------
    -- 1. Navigation (The "F-Row" Standard)
    -- ------------------------------------------------------------------
    -- F5: Start execution or Continue (if already running)
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },

    -- F10: Step Over (Run current line, don't go inside functions)
    { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },

    -- F11: Step Into (Go inside the function on this line)
    { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },

    -- F12: Step Out (Finish current function and return to caller)
    { '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },

    -- ------------------------------------------------------------------
    -- 2. Breakpoints & Session Management
    -- ------------------------------------------------------------------
    -- <Leader>b: Toggle Breakpoint (Red dot)
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },

    -- <Leader>B: Set Conditional Breakpoint (e.g., "stop only if i == 5")
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Debug: Set Conditional Breakpoint' },

    -- <Leader>lp: Set Log Point (Print message to console without stopping)
    { '<leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = 'Debug: Set Log Point' },

    -- <Leader>dr: Restart the session (Kill and restart)
    { '<leader>dr', function() require('dap').restart() end, desc = 'Debug: Restart Session' },

    -- <Leader>dl: Run Last (Re-run the last debug configuration - great for repetitive testing)
    { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last Configuration' },

    -- <Leader>dt: Terminate (Stop everything and close UI)
    { '<leader>dt', function()
        require('dap').terminate()
        require('dapui').close()
    end, desc = 'Debug: Terminate Session & Close UI' },

    -- ------------------------------------------------------------------
    -- 3. UI & Variable Inspection
    -- ------------------------------------------------------------------
    -- <Leader>du: Toggle the UI (Open/Close sidebar and console)
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle DAP UI' },

    -- <Leader>dh: Hover (Show value of variable under cursor in a floating window)
    { '<leader>dh', function()
        require('dap.ui.widgets').hover()
    end, mode = {'n', 'v'}, desc = 'Debug: Hover Variable Value' },

    -- <Leader>de: Eval (Evaluate expression under cursor or selection)
    { '<leader>de', function()
        require('dapui').eval()
    end, mode = {'n', 'v'}, desc = 'Debug: Evaluate Expression' },

    -- Optional: Use K (Shift+k) to hover while debugging
    { 'K', function()
        require('dap.ui.widgets').hover()
    end, desc = 'Debug: Hover Variable Value (K)' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'codelldb' },
    }

    dapui.setup {
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

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Configure C++ adapter
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = 'codelldb',
        args = { '--port', '${port}' },
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.getcwd() .. '/' .. vim.fn.expand '%:t:r'
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.c = dap.configurations.cpp
    dap.configurations.rust = dap.configurations.cpp
  end,
}
