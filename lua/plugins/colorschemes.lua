return {
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function()
      require('kanagawa').setup {
        theme = 'wave',
      }
      local c_logic = require('colorscheme_logic')
      c_logic.setup()
      c_logic.init()
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
  { "rose-pine/neovim", name = "rose-pine" },
  { "sainnhe/everforest" },
  { "maxmx03/solarized.nvim" },
  { "navarasu/onedark.nvim" },
  { "tiagovla/tokyodark.nvim" },
}



