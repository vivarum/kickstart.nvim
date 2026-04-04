return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      vim.opt.background = 'dark'
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      -- vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
      }
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        variant = 'wave', -- wave, dragon, lotus
      }
      -- vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'medium' -- hard, medium, soft
      vim.g.gruvbox_material_foreground = 'original' -- material, mix, original

      -- vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup {
        variant = 'moon', -- auto, main, moon, dawn
      }
    end,
  },
  {
    'marko-cerovac/material.nvim',
    priority = 1000,
    config = function()
      vim.g.material_style = 'deep ocean' -- darker, lighter, oceanic, palenight, deep ocean
    end,
  },
  {
    'neanias/everforest-nvim',
    version = false,
    priority = 1000, -- Make sure it loads before other plugins
    lazy = false, -- Load on startup
    config = function()
      require('everforest').setup {
        -- Options: 'hard', 'medium' (default), 'soft'
        background = 'hard',
        -- Makes the background transparent (great for Alacritty)
        -- transparent_background_level = 0,
        -- Better for C++: highlights constants and functions clearly
        ui_contrast = 'low',
        -- dim_inactive_windows = false,
        -- on_highlights = function(hl, palette)
        --   hl.Normal = { bg = '#1c2120' }
        --   hl.NormalNC = { bg = '#1a1f1e' }
        --   hl.SignColumn = { bg = '#1c2120' }
        --   hl.NormalFloat = { bg = '#1c2120' }
        --   hl.FloatBorder = { bg = '#1c2120' }
        -- end,
        -- on_highlights = function(hl, palette)
        --   -- Make functions more vivid green
        --   hl['@function'] = { fg = palette.green, bold = true }
        --   -- Make types more vivid yellow
        --   hl['@type'] = { fg = palette.yellow, bold = false }
        --   -- Make keywords pop more
        --   hl['@keyword'] = { fg = palette.red, bold = false }
        -- end,
      }
      -- Activate the theme
      -- vim.cmd [[colorscheme everforest]]
    end,
  },
  {
    'xiantang/darcula-dark.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'savq/melange-nvim',
    priority = 1000,
    lazy = false,
    config = function()
      vim.o.background = 'dark'
      -- vim.cmd [[colorscheme melange]]
    end,
  },
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    ---@type solarized.config
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      require('solarized').setup(opts)
      -- vim.cmd.colorscheme 'solarized'
    end,
  },
  {
    'ribru17/bamboo.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('bamboo').setup {
        style = 'vulgaris', -- vulgaris (default), multiplex, light
      }
      -- vim.cmd [[colorscheme bamboo]]
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    config = function() vim.cmd [[colorscheme nightfox]] end,
  },
  {
    'sainnhe/sonokai',
    priority = 1000,
    config = function()
      vim.o.background = 'dark'
      vim.g.sonokai_style = 'andromeda'
      vim.g.sonokai_better_performance = 1
    end,
  },
  {
    'sainnhe/edge',
    priority = 1000,
    config = function()
      vim.o.background = 'dark'
      vim.g.edge_style = 'default'
      vim.g.edge_better_performance = 1
    end,
  },
}