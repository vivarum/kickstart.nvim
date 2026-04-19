-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Terminal-mode window navigation
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Move to left window' })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = 'Move to bottom window' })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Move to top window' })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Move to right window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

------------------------
-- treesitter-context --
------------------------
-- jump to the context (useful to see where you are)
vim.keymap.set('n', ';c', function() require('treesitter-context').go_to_context(vim.v.count1) end, { desc = 'Jump to context' })

-----------------------
-- nvim-tree keymaps --
-----------------------
-- Toggle the file explorer
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })

-- Focus the tree if it's already open
vim.keymap.set('n', '<leader>ef', ':NvimTreeFocus<CR>', { desc = 'Focus NvimTree' })

-- Map '\' to toggle the tree instantly
-- vim.keymap.set('n', '\\', ':NvimTreeToggle<CR>', { silent = true, desc = 'Toggle NvimTree' })
vim.keymap.set('n', '\\', '<cmd>lua Snacks.explorer()<cr>', { silent = true, desc = 'Toggle Explorer' })

----------
-- tabs --
----------
vim.keymap.set('n', '<A-l>', ':tabnext<CR>')
vim.keymap.set('n', '<A-h>', ':tabprev<CR>')
vim.keymap.set('t', '<A-l>', '<C-\\><C-n>:tabnext<CR>')
vim.keymap.set('t', '<A-h>', '<C-\\><C-n>:tabprev<CR>')
vim.keymap.set('i', '<A-l>', '<Esc>:tabnext<CR>')
vim.keymap.set('i', '<A-h>', '<Esc>:tabprev<CR>')

--------------------------
-- resize split windows --
--------------------------
vim.keymap.set('n', '<A-Left>', '<C-w><')
vim.keymap.set('n', '<A-Right>', '<C-w>>')
vim.keymap.set('n', '<A-k>', '<C-w>+')
vim.keymap.set('n', '<A-j>', '<C-w>-')

----------------
-- blame.nvim --
----------------
-- Keymap to toggle the full-file blame window
vim.keymap.set('n', '<A-a>', '<cmd>BlameToggle<CR>', { desc = 'Git Blame Toggle' })

----------------
-- outline.nvim --
----------------
vim.keymap.set('n', '<leader>a', '<cmd>Outline<CR>')

--------------------------------
-- travel across tags keymaps --
--------------------------------
vim.keymap.set('n', '<A-D-Left>', '<C-o>', { desc = 'Jump back in jump list' })
vim.keymap.set('n', '<A-D-Right>', '<C-i>', { desc = 'Jump forward in jump list' })

---------------
-- dadbod UI --
---------------
vim.keymap.set('n', '<leader>dq', function()
  require('telescope.builtin').find_files {
    prompt_title = 'Saved DB Queries',
    cwd = vim.fn.expand '~/.local/share/db_ui',
    file_ignore_patterns = { 'connections.json' },
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)
        vim.cmd('edit ' .. selection.path)
        -- Let DBUI attach to this buffer
        vim.cmd 'DBUIFindBuffer'
      end)
      return true
    end,
  }
end, { desc = 'DB: Find saved queries' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    vim.keymap.set('n', 'T', function()
      local start_line = vim.fn.search('^$', 'bnW')
      local end_line = vim.fn.search('^$', 'nW')
      vim.cmd((start_line == 0 and 1 or start_line + 1) .. ',' .. (end_line == 0 and vim.fn.line '$' or end_line - 1) .. 'DB')
    end, { buffer = true, desc = 'DB: Execute block until empty line' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql', 'mysql', 'plsql' },
  callback = function()
    vim.keymap.set('n', 't', function()
      -- Search backward for the previous semicolon
      local prev_semi = vim.fn.search(';', 'bnW')
      -- Search forward for the next semicolon
      local next_semi = vim.fn.search(';', 'nW')

      -- Logic for range:
      -- Start: line after the previous semicolon (or line 1)
      local start_line = (prev_semi == 0) and 1 or (prev_semi + 1)

      -- End: the line containing the next semicolon (or end of file)
      local end_line = (next_semi == 0) and vim.fn.line '$' or next_semi

      -- Execute the range
      vim.cmd(start_line .. ',' .. end_line .. 'DB')
    end, { buffer = true, desc = 'DB: Execute statement until semicolon' })
  end,
})


-- Keybinding for the Snacks symbol picker
vim.keymap.set('n', '<leader>sp', function()
  Snacks.picker.lsp_symbols {
    layout = { preset = 'vscode' }, -- Or "vertical" to see more info
    win = {
      input = {
        keys = {
          ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        },
      },
    },
  }
end, { desc = 'LSP Symbols (Snacks)' })

-- Snacks toggle terminal on and off
vim.keymap.set({ 'n', 't' }, '<C-A-p>', function() Snacks.terminal.toggle() end)
