return {
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>DO', '<cmd>DiffviewOpen<cr>', desc = 'Diffview [O]pen' },
      { '<leader>DC', '<cmd>DiffviewClose<cr>', desc = 'Diffview [C]lose' },
      { '<leader>Dt', '<cmd>DiffviewToggleFiles<cr>', desc = 'Diffview [t]oggle sidebar' },
      { '<leader>Dc', '<cmd>DiffviewOpen HEAD~1<cr>', desc = 'Diffview current [c]ommit vs parent commit' },
      { '<leader>Dh', '<cmd>DiffviewOpen HEAD<cr>', desc = 'Diffview current commit vs [h]ead' },
    },
    opts = {
      hooks = {
        -- Close the file panel by default when opening diffview
        view_opened = function()
          vim.cmd('DiffviewToggleFiles')
        end,
      },
    },
  },
}
