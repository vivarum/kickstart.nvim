return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Enable the modules you want
    animate = { enabled = true },
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        files = {
          layout = {
            layout = { width = 0.95, height = 0.95 },
          },
        },
        grep = {
          layout = {
            layout = { width = 0.95, height = 0.95 },
          },
        },
        smart = {
          layout = {
            layout = { width = 0.95, height = 0.95 },
          },
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    terminal = {
      shell = 'fish',
    },
  },
  keys = {
    -- Top pickers (Replacing Telescope defaults)
    { '<leader>ns', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    { '<leader>nf', function() Snacks.picker.files() end, desc = 'Search Files' },
    { '<leader>ng', function() Snacks.picker.grep() end, desc = 'Grep Search' },
    { '<leader>nw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
    { '<leader>nb', function() Snacks.picker.lines() end, desc = 'Buffer Lines' },
    { '<leader>nR', function() Snacks.picker.resume() end, desc = 'Resume last picker' },
    -- Git
    { '<leader>gb', function() Snacks.picker.git_branches() end, desc = 'Git Branches' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log' },
  },
}
