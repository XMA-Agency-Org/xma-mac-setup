# Mac Setup Guide

## What did this install?

Your Mac now has a set of tools that make working in the terminal faster and smarter. Here's everything you need to know to use them.

---

## Step 1 — Open your terminal

You now have **Kitty** — a fast, modern terminal app. Open it from your Applications folder or Spotlight (`cmd+space` → type "Kitty" → press Enter).

This is where you type commands. Think of it like texting your computer.

---

## Step 2 — Authenticate Claude

The first time, you need to log in:

```
claude
```

Type that and press Enter. Follow the instructions to connect your Anthropic account.

---

## Using Kitty (your terminal app)

### Tabs — like browser tabs

| What you want | Keys |
|---|---|
| Open a new tab | `cmd+t` |
| Close current tab | `cmd+w` |
| Switch to next tab | `cmd+]` |
| Switch to previous tab | `cmd+[` |

### Split screen — two terminals side by side

| What you want | Keys |
|---|---|
| Split screen left/right | `cmd+d` |
| Split screen top/bottom | `cmd+shift+d` |

### Other

| What you want | Keys |
|---|---|
| Make text bigger | `cmd+=` |
| Make text smaller | `cmd+-` |
| Reset text size | `cmd+0` |
| Fullscreen | `ctrl+cmd+f` |

---

## Typing commands — tips

### Autocomplete
Start typing a command or folder name and press **Tab** — a menu pops up with options. Use arrow keys to pick one, press Enter to confirm.

### Autosuggestions
As you type, you'll see a faded suggestion based on your history.
- Press **ctrl+space** to accept it
- Keep typing to ignore it

### Search your history
Forgot a command you ran before? Press **ctrl+r** and start typing — it fuzzy-searches everything you've ever typed.

### Arrow keys
Press **↑** to go back through previous commands. Press **↓** to go forward.

---

## Navigating folders

The terminal starts in your home folder (`/Users/yourname`). Think of folders like directories on a map.

| What you type | What it does |
|---|---|
| `work` | Go to your Work folder |
| `..` | Go up one folder |
| `...` | Go up two folders |
| `cd foldername` | Go into a folder called "foldername" |
| `ls` | See what's in the current folder |
| `ll` | See files with details (size, date, permissions) |
| `lt` | See files as a tree (shows subfolders) |

**Pro tip:** Type part of a folder name and press Tab — it will complete it for you or show options.

---

## Reading files

| What you type | What it does |
|---|---|
| `cat filename.txt` | Show contents of a file with colors |
| `find filename` | Search for a file by name |
| `grep "word" filename` | Search for a word inside a file |

---

## Git — saving and sharing code

Git is a tool for saving versions of your work. Think of it like "track changes" in Google Docs.

| What you type | What it does |
|---|---|
| `gs` | See what files you've changed |
| `ga filename` | Mark a file ready to save |
| `gc -m "message"` | Save a snapshot with a description |
| `gp` | Upload your changes to GitHub |
| `gl` | Download latest changes from GitHub |
| `gd` | See exactly what you changed |
| `glog` | See full history of saves |

### Basic git workflow
```
gs              ← check what changed
ga .            ← mark everything
gc -m "my changes"   ← save snapshot
gp              ← upload to GitHub
```

---

## Claude AI

| What you type | What it does |
|---|---|
| `cc` | Open Claude chat in terminal |
| `claude` | Same thing, full name |
| `claude /help` | See all available commands |

### Generate an image with AI
```
/gen a sunset over mountains
```
Type `/gen` followed by a description of what you want. The image will be saved to your current folder.

---

## Prompt — what the blinking line means

Your prompt (the line where you type) shows useful info:

```
╭─  ~/Work/my-project  on  main (!+?)
╰─ ❯
```

| Symbol | Meaning |
|---|---|
| `~/Work/my-project` | You are inside this folder |
| ` main` | You are on the "main" git branch |
| `!` | You have unsaved file changes |
| `+` | You have changes ready to save |
| `?` | There are new untracked files |
| `❯` | Type your command here |
| `❯` (red) | Last command failed |

---

## Something went wrong?

- **Command not found** — check spelling, make sure you pressed Enter
- **Permission denied** — add `sudo` before the command (it runs as admin)
- **Stuck / nothing happening** — press `ctrl+c` to cancel and get your prompt back
- **Accidentally in a weird mode** — press `ctrl+c` or type `q` and press Enter

---

## Quick reference card

```
cc          → chat with Claude
work        → go to Work folder
ls / ll     → list files
cat file    → read a file
find name   → search for file
gs          → git status
ga .        → stage all changes
gc -m "msg" → commit changes
gp          → push to GitHub
ctrl+space  → accept suggestion
ctrl+r      → search command history
tab         → autocomplete
```
