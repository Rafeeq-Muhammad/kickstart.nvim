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
# 1. Download and trust Aftman
curl -L https://github.com/LPGhatguy/aftman/releases/latest/download/aftman-linux-amd64.zip -o aftman.zip
unzip aftman.zip

# 2. Self-install (Updates paths automatically)
./aftman self-install

# 3. Reload shell configuration (so 'aftman' is in PATH)
source ~/.config/fish/config.fish

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
  opts = {
    platform = {
      type = "roblox",
    },
    sourcemap = {
      enabled = true,
      autogenerate = false, -- We handle this manually via CLI for performance
      rojo_project_file = "default.project.json",
    },
    types = {
      roblox_security_level = "PluginSecurity", -- Useful for plugin dev
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
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
