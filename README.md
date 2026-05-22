# XMA Mac Setup

One-command Mac setup for XMA Agency — installs and configures everything a new machine needs.

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/XMA-Agency-Org/xma-mac-setup/main/setup.sh)
```

After the script finishes, restart your terminal and run `claude` to log in.

## What Gets Installed

| Category | Tools |
|---|---|
| Package manager | Homebrew |
| Runtime | Node.js (via fnm), Bun |
| Terminal | Kitty, Zsh, Starship prompt |
| Shell plugins | zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab, zoxide, fzf |
| Git | Git, lazygit, delta (diff viewer) |
| AI | Claude Code CLI |
| Dev tools | bat, eza, ripgrep, fd, jq, gh |
| Fonts | JetBrains Mono Nerd Font |

## What Gets Configured

- `.zshrc` with aliases, plugins, and prompt
- Kitty terminal with Catppuccin Mocha theme
- Git global config (delta pager, useful defaults)
- macOS system defaults (key repeat, Dock, etc.)
- Claude Code global settings and skills

## Guide

Open `index.html` in a browser for the full beginner-friendly reference — shortcuts, commands, git workflow, troubleshooting.

## CI

Every push to `setup.sh` runs the script on a fresh `macos-latest` GitHub Actions runner.
