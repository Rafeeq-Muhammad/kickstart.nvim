return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        theme = 'wave',
      }
      vim.cmd.colorscheme 'kanagawa-wave'
      require('colorscheme_logic').setup()
    end,
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "scottmckendry/cyberdream.nvim" },
  { "folke/tokyonight.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "Mofiqul/dracula.nvim" },
  { "projekt0n/github-nvim-theme" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "sainnhe/gruvbox-material" },
}

