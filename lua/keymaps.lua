-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
--
-- Disable god-annoying f1 opens help menu
-- Disable F1 in Normal, Visual, and Operator-pending modes
vim.keymap.set({'n', 'v', 'o'}, '<F1>', '<nop>')
-- Disable F1 in Insert mode
vim.keymap.set('i', '<F1>', '<nop>')


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
vim.keymap.set('n', '<C-w>m', '<C-w>_<C-w>|', { desc = 'Max out window height and width' })

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

-- Copy file directory to clipboard
vim.keymap.set('n', '<leader>cfd', function()
  local path = vim.fn.expand '%:p:h'
  if path == '' then
    vim.notify('No file directory to copy', vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('+', path)
  vim.notify('Copied file directory: ' .. path)
end, { desc = '[C]opy [F]ile [D]irectory' })

-- Replace leetcode input format
vim.keymap.set('n', '<leader>li', [[:s/\[/\{/g | s/\]/\}/g<CR>]], { desc = 'replace [l]eetcode [i]nput', silent = true })

-- Buffer Delete current buffer
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete current buffer' })

-- Buffer Delete all other buffers
vim.keymap.set('n', '<leader>bD', function()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current_buf then
      if vim.api.nvim_buf_is_valid(buf) and vim.fn.buflisted(buf) == 1 then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end
end, { desc = '[b]uffer [D]elete all other buffers' })

-- Change directory to current directory
vim.keymap.set('n', '<leader>cd', '<cmd>cd %:p:h<CR>', { desc = '[c]hange [d]irectory to current directory' })

-- Change directory to parent directory
vim.keymap.set('n', '<leader>.', '<cmd>cd ..<CR>', { desc = 'change directory to parent directory' })

-- Toggle Aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<CR>', { desc = 'Toggle Aerial' })

-- Persistence
vim.keymap.set('n', '<leader>pl', function() require('persistence').load({ last = true }) end, { desc = '[p]ersistence [l]oad last session' })

-- Compile C++ file with g++
vim.keymap.set('n', '<leader>G', function()
  local file = vim.fn.expand '%'
  local output = vim.fn.expand '%:r'
  if file:match '%.cpp$' or file:match '%.cc$' then
    vim.cmd('!g++ -g ' .. file .. ' -o ' .. output)
  else
    vim.notify('Not a C++ file', vim.log.levels.WARN)
  end
end, { desc = '[g]++ compile' })

-- Cycle Kanagawa variants without relying on vim.g.colors_name
local kanagawa_variants = { 'kanagawa-wave', 'kanagawa-dragon', 'kanagawa-lotus' }
local kanagawa_group = vim.api.nvim_create_augroup('kanagawa-variant-tracker', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Remember the currently loaded Kanagawa variant',
  group = kanagawa_group,
  pattern = 'kanagawa*',
  callback = function(event)
    for _, name in ipairs(kanagawa_variants) do
      if name == event.match then
        vim.g.__kanagawa_active_variant = name
        return
      end
    end
  end,
})

local function set_kanagawa_variant(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  if not ok then
    vim.notify('Failed to load ' .. name .. ': ' .. err, vim.log.levels.ERROR)
    return
  end
  vim.g.__kanagawa_active_variant = name
end

local function cycle_kanagawa_variant()
  local current = vim.g.__kanagawa_active_variant
  local idx = 0
  for i, name in ipairs(kanagawa_variants) do
    if name == current then
      idx = i
      break
    end
  end

  local next_variant = kanagawa_variants[(idx % #kanagawa_variants) + 1]
  set_kanagawa_variant(next_variant)
end

vim.keymap.set('n', '<leader>k', cycle_kanagawa_variant, { desc = 'Cycle Kanagawa variants' })

-- Delete screenshots
vim.keymap.set('n', '<leader>ds', function()
  vim.cmd '!rm /home/rafeeqm/workspace/website/ai_prompts/screenshots/*'
end, { desc = '[d]elete [s]creenshots' })

-- 2. Build with <Leader>b (assuming your leader is Space)
vim.keymap.set('n', '<leader>stmb', '<cmd>make -j8<CR>', { desc = 'Build Project' })

-- 3. Flash with <Leader>f
-- We use '!' to run a shell command.
vim.keymap.set('n', '<leader>stmf', '<cmd>!stmflash<CR>', { desc = 'Flash Firmware' })

