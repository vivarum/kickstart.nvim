-- debug.lua
--
-- DAP configuration for C++ debugging via codelldb (Mason-managed).

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Mason: installs codelldb automatically
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Inline variable values as virtual text while stepping through code
    'theHamsta/nvim-dap-virtual-text',
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F4>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>b', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Conditional Breakpoint' },
    -- F7 and <leader>du both toggle the UI — keep whichever you prefer
    { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
    -- { '<leader>di', function() require('dap.ui.widgets').hover() end, desc = 'Debug: Inspect variable under cursor' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- ─── Virtual Text (inline variable values) ──────────────────────────────
    require('nvim-dap-virtual-text').setup {
      enabled = true,
      enabled_commands = true, -- adds :DapVirtualTextEnable / Disable / Toggle
      highlight_changed_variables = true, -- highlight vars that changed since last step
      highlight_new_as_changed = false,
      show_stop_reason = true, -- show why execution stopped (breakpoint, exception…)
      commented = false, -- prefix virtual text with comment string
      virt_text_pos = 'eol', -- 'eol' | 'inline' | 'right_align'
      all_frames = false, -- show values from all stack frames, not just current
    }

    -- ─── DAP UI ─────────────────────────────────────────────────────────────
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
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

    -- Change breakpoint icons (uncomment and adjust to taste)
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    -- Auto open/close UI with the debug session
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

    -- <C-r> history search in the DAP REPL.
    -- nvim-dap doesn't expose its history publicly, so we maintain our own
    -- by intercepting <CR> to capture each command as it's submitted.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dap-repl',
      callback = function(args)
        local buf = args.buf
        local repl_history = {}
        local picker_open = false

        -- Capture the command on every Enter before nvim-dap processes it
        vim.keymap.set('i', '<CR>', function()
          if picker_open then return end -- suppress CR fired by picker closing
          local line = vim.api.nvim_get_current_line()
          local prompt = vim.fn.prompt_getprompt(buf)
          local input = line:sub(#prompt + 1):gsub('^%s+', ''):gsub('%s+$', '')
          if input ~= '' and repl_history[#repl_history] ~= input then table.insert(repl_history, input) end
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
        end, { buffer = buf })

        -- <C-r> opens a picker over the captured history (newest first)
        vim.keymap.set('i', '<C-r>', function()
          if vim.tbl_isempty(repl_history) then return end
          local reversed = {}
          for i = #repl_history, 1, -1 do
            table.insert(reversed, repl_history[i])
          end
          picker_open = true
          vim.ui.select(reversed, {
            prompt = 'REPL history:',
          }, function(choice)
            vim.schedule(function()
              picker_open = false
              if choice then vim.api.nvim_put({ choice }, 'c', true, true) end
            end)
          end)
        end, { buffer = buf })
      end,
    })

    -- ─── Mason (codelldb) ────────────────────────────────────────────────────
    -- codelldb is a dedicated C/C++ DAP adapter — far more stable than raw GDB DAP.
    -- Mason will install it automatically on first launch.
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = { 'codelldb' },
    }

    -- ─── C++ — codelldb adapter ─────────────────────────────────────────────
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Helper: pick from all running processes (all users, full paths)
    local function pick_process_all_users()
      return coroutine.create(function(co)
        local output = vim.fn.systemlist 'ps -ef'
        local processes = {}
        for i = 2, #output do -- skip header
          table.insert(processes, output[i])
        end

        vim.ui.select(processes, {
          prompt = 'Select process to attach (All Users):',
        }, function(choice)
          if choice then
            -- PID is the second column in `ps -ef` output
            local pid = tonumber(choice:match '%s*%S+%s+(%d+)')
            coroutine.resume(co, pid)
          else
            coroutine.resume(co, nil)
          end
        end)
      end)
    end

    dap.configurations.cpp = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = function() return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file') end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
      {
        name = 'Attach to Process',
        type = 'codelldb',
        request = 'attach',
        pid = pick_process_all_users,
        args = {},
      },
    }
  end,
}
