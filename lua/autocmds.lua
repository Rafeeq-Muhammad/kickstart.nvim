-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- High-contrast diff highlights that survive colorscheme switches
local function apply_diff_highlights()
  local palette = vim.o.background == 'light' and {
    DiffAdd = { fg = '#0f2b1f', bg = '#baf5c7' },
    DiffChange = { fg = '#10213a', bg = '#cfe2ff' },
    DiffDelete = { fg = '#311111', bg = '#ffc7c7' },
    DiffText = { fg = '#241600', bg = '#ffe29e', bold = true },
  } or {
    DiffAdd = { fg = '#e5ffef', bg = '#0b6e46' },
    DiffChange = { fg = '#e3efff', bg = '#124f7b' },
    DiffDelete = { fg = '#ffecec', bg = '#8c1e24' },
    DiffText = { fg = '#1a1200', bg = '#c28a0f', bold = true },
  }

  for group, opts in pairs(palette) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

local diff_group = vim.api.nvim_create_augroup('custom-diff-highlights', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Force high-contrast diff colors',
  group = diff_group,
  callback = function()
    vim.schedule(apply_diff_highlights)
  end,
})

-- Apply once on startup in case a colorscheme was already loaded
vim.schedule(apply_diff_highlights)

-- High-contrast selection/search highlights (Visual and Search can be too subtle in some themes)
local function apply_selection_highlights()
  local palette = vim.o.background == 'light' and {
    Visual = { bg = '#0d3a78', fg = '#e9f2ff', bold = true },
    VisualNOS = { bg = '#0d3a78', fg = '#e9f2ff', bold = true },
    Search = { bg = '#eab308', fg = '#0f172a', bold = true },
    IncSearch = { bg = '#c47100', fg = '#0f172a', bold = true },
    CurSearch = { bg = '#eab308', fg = '#0f172a', bold = true },
  } or {
    Visual = { bg = '#1f6feb', fg = '#0b0d10', bold = true },
    VisualNOS = { bg = '#1f6feb', fg = '#0b0d10', bold = true },
    Search = { bg = '#f6c177', fg = '#0b0d10', bold = true },
    IncSearch = { bg = '#e0af68', fg = '#0b0d10', bold = true },
    CurSearch = { bg = '#f6c177', fg = '#0b0d10', bold = true },
  }

  for group, opts in pairs(palette) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

local selection_group = vim.api.nvim_create_augroup('custom-selection-highlights', { clear = true })
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Force high-contrast Visual/Search highlights',
  group = selection_group,
  callback = function()
    vim.schedule(apply_selection_highlights)
  end,
})

vim.schedule(apply_selection_highlights)
