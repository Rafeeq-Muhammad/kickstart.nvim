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
        minimum_width = 40,
        max_width = 40,
        render = 'wrapped-compact'
      }
      vim.notify = notify
    end,
  },
}
