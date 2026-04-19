return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'BufReadPost',
  config = function()
    -- Force override the cpp context query
    vim.treesitter.query.set(
      'cpp',
      'context',
      [[
    (namespace_definition
      body: (_
        (_) @context.end)) @context
    (class_specifier
      body: (_
        (_) @context.end)) @context
    (struct_specifier
        body: (_
          (_) @context.end)) @context
    (linkage_specification
      body: (declaration_list
        (_) @context.end)) @context
    (function_definition
      body: (_
        (_) @context.end)) @context
  ]]
    )

    require('treesitter-context').setup {
      enable = true,
      max_lines = 4, -- max lines the context window can take up
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 1, -- max lines for a single context line
      trim_scope = 'outer', -- which context lines to drop if too many
      mode = 'topline', -- 'cursor' or 'topline'
      separator = nil, -- separator line between context and code (nil to disable)
    }
  end,
}
