local M = {}

-- 1. Option Factories
local function OptBackground(value)
  return { type = 'post', apply = function() vim.o.background = value end }
end

local function OptGlobal(name, value)
  return { type = 'pre', apply = function() vim.g[name] = value end }
end

-- 2. The Registry
-- Key = Your custom ID for the variation
-- Value = Configuration (including the 'real_name' if different from key)
local registry = {
  -- === Gruvbox Material Variations ===
  ['gruvbox-dark-hard'] = {
    real_name = 'gruvbox-material', -- The actual vim command
    options = {
      OptGlobal('gruvbox_material_background', 'hard'),
      OptBackground('dark'),
    }
  },
  ['gruvbox-dark-medium'] = {
    real_name = 'gruvbox-material',
    options = {
      OptGlobal('gruvbox_material_background', 'medium'),
      OptBackground('dark'),
    }
  },
  ['gruvbox-light-hard'] = {
    real_name = 'gruvbox-material',
    options = {
      OptGlobal('gruvbox_material_background', 'hard'),
      OptBackground('light'),
    }
  },

  -- === TokyoNight Variations ===
  -- Tokyonight handles variants via different names mostly, but sometimes config
  ['tokyonight-storm'] = {
    -- No real_name needed because 'tokyonight-storm' IS the command
    options = { OptBackground('dark') }
  },
  ['tokyonight-day'] = {
    options = { OptBackground('light') }
  },
  ['tokyonight-moon'] = {
    options = { OptBackground('dark') }
  },

  -- === Catppuccin Variations ===
  ['catppuccin-latte'] = {
    options = { OptBackground('light') }
  },
  ['catppuccin-mocha'] = {
    options = { OptBackground('dark') }
  },

  -- === Kanagawa Variations ===
  ['kanagawa-wave'] = {
    options = { OptBackground('dark') }
  },
  ['kanagawa-dragon'] = {
    options = { OptBackground('dark') }
  },
  ['kanagawa-lotus'] = {
    options = { OptBackground('light') }
  },

  -- === Others ===
  ['oxocarbon']  = { options = { OptBackground('dark') } },
  ['cyberdream'] = { options = { OptBackground('dark') } },
  ['nightfox']   = { options = { OptBackground('dark') } },
  ['dayfox']     = { options = { OptBackground('light') } },
  ['dracula']    = { options = { OptBackground('dark') } },
  ['github_light'] = { options = { OptBackground('light') } },
}

-- 3. The Order
-- These keys MUST exist in the registry above
local ordered_schemes = {
  -- Darks
  'kanagawa-wave',
  'kanagawa-dragon',
  'gruvbox-dark-hard',
  'tokyonight-storm',
  'catppuccin-mocha',
  'oxocarbon',
  'cyberdream',
  'nightfox',
  'dracula',

  -- Lights
  'kanagawa-lotus',
  'gruvbox-light-hard',
  'tokyonight-day',
  'catppuccin-latte',
  'dayfox',
  'github_light',
}

-- 4. The Logic
function M.cycle_colorscheme()
  -- Default to the first scheme if our global is missing
  local current_alias = vim.g.gemini_last_colorscheme or ordered_schemes[1]

  local idx = 0
  for i, alias in ipairs(ordered_schemes) do
    if alias == current_alias then
      idx = i
      break
    end
  end

  -- Calculate next index
  local next_idx = (idx % #ordered_schemes) + 1
  local next_alias = ordered_schemes[next_idx]
  
  -- Retrieve config from registry
  local config = registry[next_alias] or {}
  local options = config.options or {}
  
  -- Determine the actual command to run. 
  -- If 'real_name' is defined, use it. Otherwise, use the alias itself.
  local scheme_command = config.real_name or next_alias

  -- 1. Apply Pre-load options
  for _, opt in ipairs(options) do
    if opt.type == 'pre' then opt.apply() end
  end

  -- 2. Run colorscheme command
  local ok, err = pcall(vim.cmd.colorscheme, scheme_command)

  if ok then
    -- 3. Apply Post-load options
    for _, opt in ipairs(options) do
      if opt.type == 'post' then opt.apply() end
    end
    
    -- IMPORTANT: We track 'next_alias' (our custom ID), not 'scheme_command'
    -- This ensures we know exactly which VARIATION we are on.
    vim.g.gemini_last_colorscheme = next_alias
    
    vim.notify("Colorscheme: " .. next_alias)
  else
    vim.notify("Failed to load " .. scheme_command .. ": " .. err, vim.log.levels.ERROR)
  end
end

function M.setup()
  vim.keymap.set('n', '<leader>k', M.cycle_colorscheme, { desc = 'Cycle through colorschemes' })
end

return M
