-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- {
  -- 	"gioele/vim-autoswap",
  -- 	config = function()
  -- 		-- Enable tmux support if you use tmux
  -- 		vim.g.autoswap_detect_tmux = 1
  -- 	end,
  -- },
  {
    'okuuva/auto-save.nvim',
    version = '^1.0.0',
    cmd = 'ASToggle',
    event = { 'InsertLeave', 'TextChanged' },
    opts = {
      -- Your config goes here or leave it empty
    },
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          -- numbers = "buffer_id", -- display buffer IDs
          diagnostics = 'nvim_lsp', -- show lsp diagnostics in the bufferline
          separator_style = 'slant',
          show_close_icon = false,
          show_buffer_close_icons = false, -- Add this to disable close icons on buffers
          offsets = {
            filetype = 'NvimTree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      }
    end,
  },
  {
    'tpope/vim-sleuth',
  },
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
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require 'notify'
      notify.setup {
        stages = 'fade_in_slide_out',
        timeout = 3000,
      }
      vim.notify = notify
    end,
  },
  {
    'nvim-mini/mini.diff',
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'stevearc/aerial.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
  },
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'soft'
    end,
  },
}
