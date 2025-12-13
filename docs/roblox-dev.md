Here is the synthesized guide, refining the installation workflow based on the feedback and tailoring the commands for your specific setup (WSL + Fish Shell + Neovim).

###**1. The Architecture**We are sticking to the "Best of Both Worlds" model.

* **WSL (The Server):** Hosts the code, Git, Rojo Server, and Neovim (LSP).
* **Windows (The Client):** Runs Roblox Studio and the Rojo Plugin.

###**2. Critical Prerequisites*** **Filesystem Location:** As noted, **do not** use `/mnt/c/`. Create your directory in your WSL home (`~/dev/roblox-project`). This avoids file-watcher latency that breaks Rojo.
* **Network Check:** Before connecting Studio, you can verify the WSL server is reachable from Windows by opening `http://localhost:34872` in your Windows browser. You should see a Rojo version response.

---

###**3. WSL Setup (The Correct Aftman Flow)**We will use the official `self-install` method for Aftman, which is cleaner than moving binaries manually.

**Run this in your Fish shell:**

```fish
# 1. Download the correct file (v0.3.0)
curl -L https://github.com/LPGhatguy/aftman/releases/download/v0.3.0/aftman-0.3.0-linux-x86_64.zip -o aftman.zip

# 2. Unzip it
unzip aftman.zip

# 3. Make it executable
chmod +x aftman

# 4. Run self-install
./aftman self-install

# 5. Add aftman to your path permanently
fish_add_path ~/.aftman/bin
```

*(Note: If `aftman` isn't found after this, you may need to add `set -Ua fish_user_paths $HOME/.aftman/bin` to your config).*

**Initialize the Project:**

```fish
mkdir -p ~/dev/my-game
cd ~/dev/my-game

# Initialize tools
aftman init
aftman add rojo-rbx/rojo
aftman add JohnnyMorganz/luau-lsp
aftman add JohnnyMorganz/stylua
aftman install

# Initialize Rojo structure
rojo init

```

---

###**4. Neovim & LSP Integration**To get the Neovim experience you want (intellisense for `game.Workspace`, etc.), we need to generate a source map and tell git to ignore it.

**1. The Watcher Command**
In a dedicated terminal tab, run:

```fish
rojo sourcemap --watch default.project.json --output sourcemap.json

```

* **Why:** `luau-lsp` needs this file to understand your DataModel hierarchy.
* **Git hygiene:** Add `sourcemap.json` to your `.gitignore`. You don't want to commit a massive generated JSON file.

**2. Neovim Configuration (`lazy.nvim` example)**
Ensure you are using `luau-lsp.nvim` for the best compatibility.

```lua
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
```

---

###**5. The Workflow Loop**1. **Terminal Tab 1:** `rojo serve`
* *Check:* Open `http://localhost:34872` in Windows to verify visibility.


2. **Terminal Tab 2:** `rojo sourcemap --watch ...`
* *Check:* Ensure `sourcemap.json` updates when you add a script.


3. **Neovim:** Write code.
4. **Roblox Studio:** Connect plugin (localhost:34872).

###**Recommendation for Fish Users**Since you use `fish`, running two blocking commands (`serve` and `sourcemap`) is annoying. I recommend creating a `Justfile` (if you use `just`) or a simple function in `config.fish` to run them in parallel or manage them via a multiplexer like `tmux`.

**Simple Fish Function Approach:**

```fish
function dev-roblox
    # Starts sourcemap watcher in background, then starts server
    # Kill this process group to stop both later
    rojo sourcemap --watch default.project.json --output sourcemap.json &
    rojo serve
end

```

Would you like me to help you set up a `tmux` session script so you can spin up the environment (Server pane, Sourcemap pane, Neovim pane) with one command?

---






























You should name this new file `lua/plugins/roblox.lua`.

Since you are using `lazy.nvim`, it will automatically pick up this new file as long as it is inside your `lua/plugins/` folder.

###1. The Conflict Question**Do you need to modify your existing LSP file?**
**No**, but with one condition:

* Ensure that `luau_lsp` is **NOT** listed in the `servers` table in your main LSP file. (Looking at your code, it isn't listed, so you are safe).

**Why?**
Your main LSP file uses `mason-lspconfig` to setup servers generically. `luau-lsp.nvim` is a specialized "wrapper" plugin that sets up the server for you with extra Roblox-specific magic (like the sourcemap handling). If you defined it in both places, they would fight. Keeping them in separate files is the correct approach.

###2. The Updated Code (`lua/plugins/roblox.lua`)I have updated your snippet to include **capabilities**.
In your main config, you set up `blink.cmp` capabilities for autocompletion. You need to pass those same capabilities to this plugin so your Roblox autocompletion works smoothly.

**Save this as `lua/plugins/roblox.lua`:**

```lua
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

```

###3. Handling the "Double LSP" IssueYou now have two Language Servers that handle `.lua` files:

1. **`lua_ls`** (In your main config): Great for Neovim config files.
2. **`luau_lsp`** (In this new file): Great for Roblox files.

Neovim is usually smart enough to run both, but `lua_ls` might annoy you inside a Roblox project by complaining about global variables like `game` or `workspace`.

**The Fix:**
If `lua_ls` becomes annoying in your Roblox files, create a file named `.luarc.json` in the root of your Roblox project (same folder as `default.project.json`) with this content:

```json
{
    "diagnostics": {
        "disable": ["lowercase-global", "undefined-global"]
    },
    "workspace": {
        "checkThirdParty": false,
        "ignoreDir": [".git", ".rojo", "sourcemap.json"]
    }
}

```

This tells the standard Lua server to relax while you are working on your game.

---

Prompting with Gemini/Codex: `"Use modern Luau type-checking syntax and the task library instead of wait/spawn." This fixes 80% of the bad legacy code they tend to generate.`
