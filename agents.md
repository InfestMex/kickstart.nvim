# Agent Configuration Guide

## Project Overview

This is a **Neovim configuration** based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It's a modular Neovim setup written entirely in **Lua**, not a full distribution — just a starting point for customization.

## Key Details

- **Language**: Lua (Neovim config)
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim)
- **Config Entry Point**: `init.lua` (root)
- **Location**: `%LOCALAPPDATA%\nvim\` (Windows) / `~/.config/nvim/` (Linux/macOS)

## Directory Structure

```
├── init.lua          # Main entry point — load order & global opts
├── lazy-lock.json    # Plugin lockfile (track in version control)
├── lua/
│   ├── kickstart/plugins/  # Core kickstart plugins (autopairs, debug, gitsigns, etc.)
│   ├── plugins/lsp/        # LSP configuration (lspconfig.lua)
│   └── custom/             # User overrides & custom setup
│       ├── keymaps.lua     # Custom keybindings
│       ├── plugins/        # User-installed plugins (DAP, pi-nvim, etc.)
│       └── containers.lua  # Docker/DevContainer helpers
├── ftplugin/         # Filetype-specific settings
├── doc/              # Plugin documentation
└── README.md         # Full installation & setup guide
```

## How It Works

1. `init.lua` sets global options (tab width, clipboard, etc.) and sources plugin lists from `lua/kickstart/plugins/` and `lua/custom/`.
2. Plugins are declared as Lua tables with `{ 'repo/name', opts = {...} }` syntax for lazy.nvim.
3. Keymaps are defined in `custom/keymaps.lua` using `vim.keymap.set()`.
4. LSP config lives in `plugins/lsp/lspconfig.lua`.

## Working with This Project

- **View installed plugins**: Open Neovim and run `:Lazy`
- **Install/update plugins**: Run `:Lazy sync` inside Neovim
- **Check health**: Run `:checkhealth` inside Neovim
- All plugin metadata comes from upstream repos — always check those for advanced config options.

## Notes for AI Agents

- Neovim config is Lua-first; prefer Lua patterns over VimScript unless necessary.
- The user has Windows in their environment — keep platform compatibility in mind.
- Changes to `init.lua` or plugin files should be reviewed before being applied, as they affect the entire editor experience.
- Never hardcode paths for Neovim directories — use `vim.fn.stdpath()` (e.g., `vim.fn.stdpath('data')`, `'config'`, `'cache'`).
