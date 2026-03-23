return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false, -- Load on startup so it's ready for big repos
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      -- Optimized for large C++ projects
      update_focused_file = {
        enable = true, -- Auto-reveal the file you're currently editing
        update_root = true, -- Change the root to the project root
      },
      filters = {
        dotfiles = false, -- Show hidden files if needed
        custom = { '^.git$' }, -- Hide the .git folder to save space/memory
      },
      view = {
        width = 35,
        side = 'left',
      },
      renderer = {
        group_empty = true, -- Compacts empty nested folders (e.g., src/main/cpp)
        highlight_git = true,
      },
    }
  end,
}
