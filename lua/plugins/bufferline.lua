return {
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
}
