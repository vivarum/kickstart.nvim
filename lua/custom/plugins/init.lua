-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  {
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
  },
}
