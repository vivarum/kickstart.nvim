return {
  'sakhnik/nvim-gdb',
  build = './install.sh',
  init = function()
    -- Override default keymaps to match what you're used to
    vim.g.nvimgdb_config_override = {
      key_next = '<F2>',
      key_step = '<F3>',
      key_finish = '<F4>',
      key_continue = '<F5>',
      key_breakpoint = '<leader>b',
      key_until = '<F6>',
    }
  end,
  config = function()
    vim.keymap.set('n', '<leader>dd', function()
      local pid = vim.trim(vim.fn.system 'pgrep mariadbd')
      if pid == '' then
        vim.notify('mariadbd process not found', vim.log.levels.ERROR)
        return
      end
      vim.cmd('GdbStartLLDB lldb -p ' .. pid .. ' -S /home/ubuntu/shared/mariadb-server/.lldb_breakpoints')
    end, { desc = 'Debug: Start LLDB' })

    vim.keymap.set('n', '<leader>dx', function() vim.cmd 'GdbDebugStop' end, { desc = 'Debug: Stop' })

    --------------------
    -- This is a nvim-gdb integration that syncs the current source location across two tabs when a breakpoint is hit.
    -- Here's what it does step by step:
    -- Trigger: NvimGdbBreak is a custom event fired by the nvim-gdb plugin whenever GDB hits a breakpoint and stops.
    -- Step 1 — find the source location in the current tab:
    -- It loops through all windows in the current tab, looking for a normal source code buffer (skipping terminal and scratch buffers). It grabs that buffer and the current line number.
    -- Step 2 — find the other tab and sync it:
    -- It then loops through all other tabs, finds the first normal window in each, and sets it to show the same buffer at the same line.
    -- The overall effect:
    -- You have two tabs open — one for debugging (with GDB terminals, output, etc.) and one for viewing/editing code. When GDB hits a breakpoint and jumps to a source line in the debug tab, this autocmd automatically mirrors that location in your code tab so both tabs show the same place in the source.
    -- It's essentially solving the problem of "I want to see the debugger UI in one tab and my clean code view in another, but keep them in sync when stepping through code."
    --------------------
    vim.api.nvim_create_autocmd('User', {
      pattern = 'NvimGdbBreak',
      callback = function()
        -- Find the nvim-gdb source window (non-terminal buffer with a file)
        local src_buf, src_line
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
          if bt ~= 'terminal' and bt ~= 'nofile' then
            src_buf = buf
            src_line = vim.api.nvim_win_get_cursor(win)[1]
            break
          end
        end

        if not src_buf then return end

        -- Find the other tab and sync its first normal window
        local current_tab = vim.api.nvim_get_current_tabpage()
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          if tab ~= current_tab then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
              local buf = vim.api.nvim_win_get_buf(win)
              local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
              if bt ~= 'terminal' and bt ~= 'nofile' then
                vim.api.nvim_win_set_buf(win, src_buf)
                vim.api.nvim_win_set_cursor(win, { src_line, 0 })
                return
              end
            end
          end
        end
      end,
    })
  end,
}
