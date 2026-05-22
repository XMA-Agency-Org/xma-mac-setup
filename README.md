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
| Runtime | Node.js (via fnm) |
| Terminal | Kitty, Zsh, Starship prompt |
| Shell plugins | zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search, zsh-completions, fzf-tab, zoxide, fzf |
| File manager | Yazi |
| AI | Claude Code CLI, gen (image generation) |
| Dev tools | lsd, bat, ripgrep, fd, jq |
| Fonts | JetBrains Mono Nerd Font |

## What Gets Configured

- `.zshrc` — aliases, plugins, keybindings, PATH
- Kitty — Catppuccin Mocha theme, JetBrains Mono, split/tab shortcuts
- Starship — two-line prompt with git, node, python, rust status
- Yazi — `w` key opens a shell in current directory
- macOS defaults — fast key repeat, Finder improvements, no autocorrect

## Aliases

| Alias | Command |
|---|---|
| `y` | `yazi` |
| `cc` | `claude` |
| `ls` / `ll` / `lt` | `lsd` variants |
| `cat` | `bat` |
| `find` | `fd` |
| `grep` | `rg` |
| `gs` `ga` `gc` `gp` `gl` `gd` `glog` | git shortcuts |
| `work` | `cd ~/Work` |
| `..` / `...` | `cd ..` / `cd ../..` |

## Guide

Open `index.html` in a browser for the full beginner-friendly reference — shortcuts, commands, aliases, git workflow, troubleshooting.
