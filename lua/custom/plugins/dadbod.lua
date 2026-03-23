return {
  {
    'tpope/vim-dadbod',
    dependencies = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection' },
    config = function()
      vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font

      -- Completion in sql buffers
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          require('cmp').setup.buffer {
            sources = { { name = 'vim-dadbod-completion' } },
          }
        end,
      })
    end,
  },
}
