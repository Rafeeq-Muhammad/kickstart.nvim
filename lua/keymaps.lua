-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Buffer navigation
vim.keymap.set('n', '<M-h>', '<cmd>bprevious<CR>', { desc = 'Move to the left buffer' })
vim.keymap.set('n', '<M-l>', '<cmd>bnext<CR>', { desc = 'Move to the right buffer' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Custom Keymaps (from misc.lua) ]]

-- Copy file path to clipboard
vim.keymap.set('n', '<leader>cfp', function()
  local path = vim.fn.expand '%:p'
  if path == '' then
    vim.notify('No file path to copy', vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('+', path)
  vim.notify('Copied file path: ' .. path)
end, { desc = '[C]opy [F]ile [P]ath' })

-- Replace leetcode input format
vim.keymap.set('n', '<leader>li', [[:s/\[/\{/g | s/\]/\}/g<CR>]], { desc = 'replace [l]eetcode [i]nput', silent = true })

-- Buffer Delete current buffer
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete current buffer' })

-- Buffer Delete all other buffers
vim.keymap.set('n', '<leader>bD', function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf then
      local info = vim.fn.getbufinfo(buf)[1]
      if info and info.listed then
        vim.cmd('bdelete! ' .. buf)
      end
    end
  end
end, { desc = '[b]uffer [D]elete all other buffers' })

-- Change directory to current directory
vim.keymap.set('n', '<leader>cd', '<cmd>cd %:p:h<CR>', { desc = '[c]hange [d]irectory to current directory' })

-- Toggle Aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<CR>', { desc = 'Toggle Aerial' })

-- Persistence
vim.keymap.set('n', '<leader>pl', function() require('persistence').load({ last = true }) end, { desc = '[p]ersistence [l]oad last session' })
