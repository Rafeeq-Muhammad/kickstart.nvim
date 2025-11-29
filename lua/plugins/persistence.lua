return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- This will only start session saving when an actual file was opened
    opts = {
      -- Add any custom options here
      -- Default options:
      -- dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
      -- need = 1, -- minimum number of file buffers that need to be open to save (set to 0 to always save)
      -- branch = true, -- use git branch to save session
    }
  }
}
