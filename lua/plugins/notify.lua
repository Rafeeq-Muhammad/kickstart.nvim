return {
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require 'notify'
      notify.setup {
        stages = 'fade',
        timeout = 1,
        merge_duplicates = false,
        fps = 60,
        minimum_width = 0,
      }
      vim.notify = notify
    end,
  },
}
