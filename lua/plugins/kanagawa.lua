return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        theme = 'wave',
      }
      vim.cmd.colorscheme 'kanagawa-wave'
    end,
  },
}
