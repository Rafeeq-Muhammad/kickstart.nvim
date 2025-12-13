return {
  "lopi-py/luau-lsp.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "saghen/blink.cmp", -- Depend on blink so we can get capabilities
  },
  opts = {
    platform = {
      type = "roblox",
    },
    sourcemap = {
      enabled = true,
      autogenerate = false, -- We handle this manually via CLI (rojo sourcemap ...)
      rojo_project_file = "default.project.json",
    },
    types = {
      roblox_security_level = "PluginSecurity",
    },
    -- Pass capabilities to the server so blink.cmp works
    server = {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
      -- Optional: Ensure it recognizes standard Lua files too, not just .luau
      filetypes = { "lua", "luau" }, 
    },
  },
}

