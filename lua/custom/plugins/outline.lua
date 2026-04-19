return {
  'hedyhli/outline.nvim',
  config = function()
    require('outline').setup {
      outline_window = {
        -- This is the magic setting you want!
        show_symbol_details = true,
      },
      symbol_folding = {
        -- Autofold can be annoying in big C++ files,
        -- set to true if you want them closed by default.
        autofold_depth = 1,
      },
    }
  end,
}
