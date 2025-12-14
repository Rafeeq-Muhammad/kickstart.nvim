return {
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require 'notify'
      notify.setup {
        stages = 'fade_in_slide_out',
        timeout = 1000,
        merge_duplicates = false,
      }
      vim.notify = notify
    end,
  },
}
