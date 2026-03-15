local M = {}

local cache_file = vim.fn.stdpath("data") .. "/last_colorscheme.txt"

local function save_colorscheme(alias)
  local f = io.open(cache_file, "w")
  if f then
    f:write(alias)
    f:close()
  end
end

local function load_colorscheme()
  local f = io.open(cache_file, "r")
  if f then
    local content = f:read("*l")
    f:close()
    if content and content ~= "" then
      return content:match("^%s*(.-)%s*$")
    end
  end
  return nil
end

-- 1. Option Factories
local function OptBackground(value)
  return { type = 'both', apply = function() vim.o.background = value end }
end

local function OptGlobal(name, value)
  return { type = 'pre', apply = function() vim.g[name] = value end }
end

local function OptOnedarkStyle(style)
  return { type = 'pre', apply = function() require('onedark').setup { style = style } end }
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
  ['kanagawa-lotus'] = {
    options = { OptBackground('light') }
  },

  -- === Rose-Pine Variations ===
  ['rose-pine-main'] = {
    real_name = 'rose-pine',
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

  -- === OneDark Variations ===
  ['onedark-dark'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('dark'), OptBackground('dark') }
  },
  ['onedark-darker'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('darker'), OptBackground('dark') }
  },
  ['onedark-cool'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('cool'), OptBackground('dark') }
  },
  ['onedark-deep'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('deep'), OptBackground('dark') }
  },
  ['onedark-warm'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('warm'), OptBackground('dark') }
  },
  ['onedark-warmer'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('warmer'), OptBackground('dark') }
  },
  ['onedark-light'] = {
    real_name = 'onedark',
    options = { OptOnedarkStyle('light'), OptBackground('light') }
  },

  -- === Others ===
  ['oxocarbon']  = { options = { OptBackground('dark') } },
  ['cyberdream'] = { options = { OptBackground('dark') } },
  ['dracula']    = { options = { OptBackground('dark') } },
  -- === GitHub Variations ===
  ['github_dark'] = { options = { OptBackground('dark') } },
  ['github_light'] = { options = { OptBackground('light') } },
  ['github_dark_dimmed'] = { options = { OptBackground('dark') } },
  ['github_dark_default'] = { options = { OptBackground('dark') } },
  ['github_light_default'] = { options = { OptBackground('light') } },
  ['github_dark_high_contrast'] = { options = { OptBackground('dark') } },
  ['github_light_high_contrast'] = { options = { OptBackground('light') } },
  ['github_dark_colorblind'] = { options = { OptBackground('dark') } },
  ['github_light_colorblind'] = { options = { OptBackground('light') } },
  ['github_dark_tritanopia'] = { options = { OptBackground('dark') } },
  ['github_light_tritanopia'] = { options = { OptBackground('light') } },

  -- === TokyoDark ===
  ['tokyodark'] = { options = { OptBackground('dark') } },
}

-- 3. The Order
-- These keys MUST exist in the registry above
local ordered_schemes = {
  -- Darks
  'kanagawa-wave',
  'gruvbox-dark-soft',
  'catppuccin-frappe',
  'rose-pine-main',
  'dracula',
  'github_dark',
  'tokyodark',

  -- Lights
  'gruvbox-light-soft',
  'everforest-light-soft',
  'tokyonight-day',
  'rose-pine-dawn',
  'dayfox',
  'dawnfox',
  'solarized-light',
  'onedark-light',
}

-- 4. The Logic
function M.apply_scheme(alias)
  -- Retrieve config from registry
  local config = registry[alias] or {}
  local options = config.options or {}

  -- Determine the actual command to run.
  -- If 'real_name' is defined, use it. Otherwise, use the alias itself.
  local scheme_command = config.real_name or alias

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

    -- IMPORTANT: We track 'alias' (our custom ID), not 'scheme_command'
    -- This ensures we know exactly which VARIATION we are on.
    vim.g.gemini_last_colorscheme = alias
    save_colorscheme(alias)
    -- vim.notify("Colorscheme: " .. alias)
  else
    vim.notify("Failed to load " .. scheme_command .. ": " .. err, vim.log.levels.ERROR)
  end
end

function M.init()
  local saved = load_colorscheme()
  local target = saved or ordered_schemes[1]
  
  -- ensure the target actually exists in our registry, fallback to first if not
  if not registry[target] then
    target = ordered_schemes[1]
  end

  M.apply_scheme(target)
end

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

  M.apply_scheme(next_alias)
end

function M.setup()
  vim.keymap.set('n', '<C-N>', function() M.cycle_colorscheme(1) end, { desc = 'Cycle colorscheme forward' })
  vim.keymap.set('n', '<C-P>', function() M.cycle_colorscheme(-1) end, { desc = 'Cycle colorscheme backward' })
end

return M



