return {
  'stevearc/aerial.nvim',
  opts = {
    filter_kind = false,
    backends = { 'lsp', 'treesitter', 'markdown' },
    on_attach = function(bufnr)
      vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
      vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
    end,
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
