local M = {}

-- 1. Option Factories
local function OptBackground(value)
  return { type = 'both', apply = function() vim.o.background = value end }
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
  ['gruvbox-dark-soft'] = {
    real_name = 'gruvbox-material',
    options = {
      OptGlobal('gruvbox_material_background', 'soft'),
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
  ['gruvbox-light-medium'] = {
    real_name = 'gruvbox-material',
    options = {
      OptGlobal('gruvbox_material_background', 'medium'),
      OptBackground('light'),
    }
  },
  ['gruvbox-light-soft'] = {
    real_name = 'gruvbox-material',
    options = {
      OptGlobal('gruvbox_material_background', 'soft'),
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
  ['tokyonight-night'] = {
    options = { OptBackground('dark') }
  },

  -- === Catppuccin Variations ===
  ['catppuccin-latte'] = {
    options = { OptBackground('light') }
  },
  ['catppuccin-mocha'] = {
    options = { OptBackground('dark') }
  },
  ['catppuccin-macchiato'] = {
    options = { OptBackground('dark') }
  },
  ['catppuccin-frappe'] = {
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

  -- === Rose-Pine Variations ===
  ['rose-pine'] = {
    options = { OptBackground('dark') }
  },
  ['rose-pine-moon'] = {
    options = { OptBackground('dark') }
  },
  ['rose-pine-dawn'] = {
    options = { OptBackground('light') }
  },

  -- === Everforest Variations ===
  ['everforest-dark-hard'] = {
    real_name = 'everforest',
    options = {
      OptGlobal('everforest_background', 'hard'),
      OptBackground('dark'),
    }
  },
  ['everforest-dark-medium'] = {
    real_name = 'everforest',
    options = {
      OptGlobal('everforest_background', 'medium'),
      OptBackground('dark'),
    }
  },
  ['everforest-dark-soft'] = {
    real_name = 'everforest',
    options = {
      OptGlobal('everforest_background', 'soft'),
      OptBackground('dark'),
    }
  },
  ['everforest-light-hard'] = {
    real_name = 'everforest',
    options = {
      OptGlobal('everforest_background', 'hard'),
      OptBackground('light'),
    }
  },
  ['everforest-light-medium'] = {
    real_name = 'everforest',
    options = {
      OptGlobal('everforest_background', 'medium'),
      OptBackground('light'),
    }
  },
  ['everforest-light-soft'] = {
    real_name = 'everforest',
    options = {
      OptGlobal('everforest_background', 'soft'),
      OptBackground('light'),
    }
  },

  -- === Nightfox Variations ===
  ['nightfox']   = { options = { OptBackground('dark') } },
  ['nordfox']    = { options = { OptBackground('dark') } },
  ['terafox']    = { options = { OptBackground('dark') } },
  ['carbonfox']  = { options = { OptBackground('dark') } },
  ['duskfox']    = { options = { OptBackground('dark') } },
  ['dayfox']     = { options = { OptBackground('light') } },
  ['dawnfox']    = { options = { OptBackground('light') } },

  -- === Solarized Variations ===
  ['solarized-dark'] = {
    real_name = 'solarized',
    options = { OptBackground('dark') },
  },
  ['solarized-light'] = {
    real_name = 'solarized',
    options = { OptBackground('light') },
  },

  -- === Others ===
  ['oxocarbon']  = { options = { OptBackground('dark') } },
  ['cyberdream'] = { options = { OptBackground('dark') } },
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
  'gruvbox-dark-medium',
  'gruvbox-dark-soft',
  'everforest-dark-hard',
  'everforest-dark-medium',
  'everforest-dark-soft',
  'tokyonight-storm',
  'tokyonight-moon',
  'tokyonight-night',
  'catppuccin-mocha',
  'catppuccin-macchiato',
  'catppuccin-frappe',
  'rose-pine',
  'rose-pine-moon',
  'nightfox',
  'nordfox',
  'terafox',
  'carbonfox',
  'duskfox',
  'solarized-dark',
  'oxocarbon',
  'cyberdream',
  'dracula',

  -- Lights
  'kanagawa-lotus',
  'gruvbox-light-hard',
  'gruvbox-light-medium',
  'gruvbox-light-soft',
  'everforest-light-hard',
  'everforest-light-medium',
  'everforest-light-soft',
  'tokyonight-day',
  'catppuccin-latte',
  'rose-pine-dawn',
  'dayfox',
  'dawnfox',
  'solarized-light',
  'github_light',
}

-- 4. The Logic
function M.cycle_colorscheme(direction)
  direction = direction or 1 -- Default to forward

  -- Default to the first scheme if our global is missing
  local current_alias = vim.g.gemini_last_colorscheme or ordered_schemes[1]

  local idx = 0
  for i, alias in ipairs(ordered_schemes) do
    if alias == current_alias then
      idx = i
      break
    end
  end

  -- Calculate next index based on direction
  local next_idx
  if direction > 0 then
    next_idx = (idx % #ordered_schemes) + 1
  else
    next_idx = idx - 1
    if next_idx < 1 then
      next_idx = #ordered_schemes
    end
  end
  local next_alias = ordered_schemes[next_idx]

  -- Retrieve config from registry
  local config = registry[next_alias] or {}
  local options = config.options or {}

  -- Determine the actual command to run.
  -- If 'real_name' is defined, use it. Otherwise, use the alias itself.
  local scheme_command = config.real_name or next_alias

  -- 1. Apply Pre-load options
  for _, opt in ipairs(options) do
    if opt.type == 'pre' or opt.type == 'both' then opt.apply() end
  end

  -- 2. Run colorscheme command
  local ok, err = pcall(vim.cmd.colorscheme, scheme_command)

  if ok then
    -- 3. Apply Post-load options
    for _, opt in ipairs(options) do
      if opt.type == 'post' or opt.type == 'both' then opt.apply() end
    end

    -- IMPORTANT: We track 'next_alias' (our custom ID), not 'scheme_command'
    -- This ensures we know exactly which VARIATION we are on.
    vim.g.gemini_last_colorscheme = next_alias
    -- vim.notify("Colorscheme: " .. next_alias)
  else
    vim.notify("Failed to load " .. scheme_command .. ": " .. err, vim.log.levels.ERROR)
  end
end

function M.setup()
  vim.keymap.set('n', '<C-N>', function() M.cycle_colorscheme(1) end, { desc = 'Cycle colorscheme forward' })
  vim.keymap.set('n', '<C-P>', function() M.cycle_colorscheme(-1) end, { desc = 'Cycle colorscheme backward' })
end

return M
