# XMA Mac Setup — Cheatsheet

## Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/XMA-Agency-Org/xma-mac-setup/main/setup.sh)
```

After install: restart terminal, then run `claude` to authenticate.

---

## Terminal — Kitty

| Shortcut | Action |
|---|---|
| `cmd+t` | New tab (same dir) |
| `cmd+w` | Close tab |
| `cmd+]` / `cmd+[` | Next / prev tab |
| `cmd+enter` | New window (same dir) |
| `cmd+d` | Split vertical |
| `cmd+shift+d` | Split horizontal |
| `cmd+=` / `cmd+-` | Font size up / down |
| `cmd+0` | Reset font size |
| `ctrl+cmd+f` | Toggle fullscreen |

Theme: **Catppuccin Mocha** · Font: **JetBrains Mono Nerd Font 14pt**

---

## Shell — Zsh

| Shortcut | Action |
|---|---|
| `ctrl+space` | Accept autosuggestion |
| `ctrl+e` | Execute autosuggestion |
| `↑` / `↓` | History substring search |
| `ctrl+r` | Fuzzy search history (fzf) |
| `ctrl+t` | Fuzzy search files (fzf) |
| `tab` | fzf-tab completion with preview |
| `<` / `>` | Switch fzf-tab groups |

---

## Aliases

### Navigation
| Alias | Command |
|---|---|
| `work` | `cd ~/Work` |
| `..` | `cd ..` |
| `...` | `cd ../..` |

### Files
| Alias | Replaces |
|---|---|
| `ls` | `lsd` |
| `ll` | `lsd -lah --git` |
| `lt` | `lsd --tree --depth=2` |
| `cat` | `bat` (syntax highlighting) |
| `find` | `fd` |
| `grep` | `ripgrep` |

### Git
| Alias | Command |
|---|---|
| `g` | `git` |
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gd` | `git diff` |
| `glog` | `git log --oneline --graph --decorate` |

### Claude
| Alias | Command |
|---|---|
| `cc` | `claude` |

---

## Tools

| Tool | What it does |
|---|---|
| **starship** | Prompt — shows git, node, python, rust status |
| **zoxide** | Smarter `cd` — type partial dir names |
| **fzf** | Fuzzy finder for files, history, completions |
| **fzf-tab** | Tab completions via fzf with file preview |
| **lsd** | `ls` with icons and color |
| **bat** | `cat` with syntax highlighting |
| **fd** | Fast `find` replacement |
| **ripgrep** | Fast `grep` replacement |
| **fnm** | Node version manager |
| **gen** | AI image generation CLI |

### Zoxide tips
```bash
cd proj        # jumps to highest-ranked dir matching "proj"
cd             # interactive fzf picker
zi             # interactive fzf jump
```

### fd examples
```bash
fd .env                  # find by name
fd -e ts                 # find by extension
fd -t d src              # find directories named src
```

### ripgrep examples
```bash
rg "TODO"                # search current dir
rg "func" --type ts      # search only .ts files
rg -l "pattern"          # list matching files only
```

---

## Claude

```bash
claude               # start chat
cc                   # same, short alias
claude /help         # list slash commands
claude skill add X   # install a skill
```

### Gen skill (AI images)
```bash
/gen a cat sitting on a desk    # generate image
```

---

## Prompt (Starship)

Two-line prompt shows:
- Current directory (truncated to 4 levels)
- Git branch + status (`?` untracked · `!` modified · `+` staged · `✘` deleted)
- Node / Bun / Python / Rust version (when in relevant project)
