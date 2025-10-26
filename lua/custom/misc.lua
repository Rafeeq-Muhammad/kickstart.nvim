local M = {}

local keymaps = {
  {
    mode = 'n',
    lhs = '<leader>cfp',
    rhs = function()
      local path = vim.fn.expand '%:p'
      if path == '' then
        vim.notify('No file path to copy', vim.log.levels.WARN)
        return
      end
      vim.fn.setreg('+', path)
      vim.notify('Copied file path: ' .. path)
    end,
    opts = { desc = '[C]opy [F]ile [P]ath' },
  },
  {
    mode = 'n',
    lhs = '<leader>li',
    rhs = [[:s/\[/\{/g | s/\]/\}/g<CR>]],
    opts = { desc = 'replace [l]eetcode [i]nput', silent = true },
  },
  {
    mode = 'n',
    lhs = '<leader>bd',
    rhs = '<cmd>bdelete<CR>',
    opts = { desc = '[B]uffer [D]elete current buffer' },
  },
  {
    mode = 'n',
    lhs = '<leader>bD',
    rhs = function()
      local current_buf = vim.api.nvim_get_current_buf()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current_buf then
          local info = vim.fn.getbufinfo(buf)[1]
          if info and info.listed then
            vim.cmd('bdelete! ' .. buf)
          end
        end
      end
    end,
    opts = { desc = '[b]uffer [D]elete all other buffers' },
  },
  {
    mode = 'n',
    lhs = '<leader>cd',
    rhs = '<cmd>cd %:p:h<CR>',
    opts = { desc = '[c]hange [d]irectory to current directory' },
  },
}

function M.setup()
  for _, map in ipairs(keymaps) do
    vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
  end
end

M.setup()

return M
