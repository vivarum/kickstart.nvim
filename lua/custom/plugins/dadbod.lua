return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    config = function()
      vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font
      vim.g.db_ui_execute_on_save = 0
    end,
  },
}
