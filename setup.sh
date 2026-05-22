#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
# XMA Claude Setup — macOS
# ─────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BLUE}▶${RESET} $*"; }
success() { echo -e "${GREEN}✓${RESET} $*"; }
warn()    { echo -e "${YELLOW}⚠${RESET} $*"; }
step()    { echo -e "\n${BOLD}━━━ $* ━━━${RESET}"; }

# ─── Homebrew ───────────────────────────────
step "Homebrew"
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew installed"
else
  success "Homebrew already installed"
  brew update --quiet
fi

# ─── Core tools ─────────────────────────────
step "Core CLI tools"
BREW_PACKAGES=(
  git
  curl
  wget
  zsh
  starship
  zoxide
  fzf
  lsd
  bat
  ripgrep
  fd
  jq
  node
  fnm
)

for pkg in "${BREW_PACKAGES[@]}"; do
  if brew list --formula "$pkg" &>/dev/null 2>&1; then
    info "$pkg already installed, skipping"
  else
    info "Installing $pkg..."
    brew install "$pkg"
  fi
done
success "Core tools ready"

# ─── Casks ──────────────────────────────────
step "Casks (fonts + apps)"
BREW_CASKS=(
  font-jetbrains-mono-nerd-font
  kitty
)

for cask in "${BREW_CASKS[@]}"; do
  if brew list --cask "$cask" &>/dev/null 2>&1; then
    info "$cask already installed, skipping"
  else
    info "Installing $cask..."
    brew install --cask "$cask"
  fi
done
success "Casks installed"

# ─── Work directory ─────────────────────────
step "Work directory"
mkdir -p "$HOME/Work"
success "~/Work created"

# ─── Zsh plugins (no framework) ─────────────
step "Zsh plugins"
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

install_plugin() {
  local name="$1" repo="$2"
  local dest="$ZSH_PLUGINS_DIR/$name"
  if [[ ! -d "$dest" ]]; then
    info "Installing $name..."
    git clone --depth=1 "$repo" "$dest"
    success "$name installed"
  else
    info "$name already installed"
  fi
}

install_plugin "zsh-autosuggestions"          "https://github.com/zsh-users/zsh-autosuggestions"
install_plugin "zsh-syntax-highlighting"      "https://github.com/zsh-users/zsh-syntax-highlighting"
install_plugin "zsh-completions"              "https://github.com/zsh-users/zsh-completions"
install_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search"
install_plugin "fzf-tab"                      "https://github.com/Aloxaf/fzf-tab"

# ─── .zshrc ─────────────────────────────────
step ".zshrc"

cat > "$HOME/.zshrc" << 'ZSHRC'
# ─── PATH ───────────────────────────────────
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$HOME/.local/bin:$PATH"

if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ─── Plugins ────────────────────────────────
ZSH_PLUGINS="$HOME/.zsh/plugins"

fpath=("$ZSH_PLUGINS/zsh-completions/src" $fpath)

source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_PLUGINS/fzf-tab/fzf-tab.plugin.zsh"
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZSH_PLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh"

# ─── Completions ────────────────────────────
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"

# ─── History ────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY EXTENDED_HISTORY

# ─── Options ────────────────────────────────
setopt AUTO_CD CORRECT COMPLETE_ALIASES GLOB_COMPLETE NO_BEEP

# ─── Plugin config ──────────────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# fzf-tab
zstyle ':fzf-tab:complete:*'    fzf-preview 'lsd --color=always $realpath 2>/dev/null || bat --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always --tree --depth=2 $realpath'
zstyle ':fzf-tab:*'             switch-group '<' '>'
zstyle ':completion:*'          menu no

# ─── fzf ────────────────────────────────────
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=dark"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ─── Zoxide ─────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"

# ─── Starship ───────────────────────────────
eval "$(starship init zsh)"

# ─── Key bindings ───────────────────────────
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down
bindkey '^ '   autosuggest-accept   # Ctrl+Space
bindkey '^@'   autosuggest-accept   # Ctrl+Space (some terminals)
bindkey '^e'   autosuggest-execute

# ─── Aliases ────────────────────────────────
alias ls="lsd"
alias ll="lsd -lah --git"
alias lt="lsd --tree --depth=2"
alias cat="bat --style=plain"
alias grep="rg"
alias find="fd"

alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias glog="git log --oneline --graph --decorate"
alias gd="git diff"

alias work="cd ~/Work"
alias ..="cd .."
alias ...="cd ../.."

alias cc="claude"
ZSHRC

success ".zshrc written"

# ─── Starship config ────────────────────────
step "Starship theme"
mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" << 'STARSHIP'
"$schema" = 'https://starship.rs/config-schema.json'

format = """
[╭─](bold bright-black)$os$directory$git_branch$git_status$nodejs$bun$rust$python$package
[╰─](bold bright-black)$character"""

add_newline = true
command_timeout = 1000

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold green)"

[os]
disabled = false
style = "bold bright-black"

[os.symbols]
Macos = "  "
Linux = "  "

[directory]
style = "bold cyan"
truncation_length = 4
truncate_to_repo = true
format = "in [$path]($style)[$read_only]($read_only_style) "

[git_branch]
symbol = " "
style = "bold purple"
format = "on [$symbol$branch]($style) "

[git_status]
style = "bold red"
format = "([$all_status$ahead_behind]($style) )"
conflicted = "⚡"
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
untracked = "?"
modified = "!"
staged = "+"
deleted = "✘"

[nodejs]
symbol = " "
style = "bold green"
format = "[$symbol($version)]($style) "

[bun]
symbol = "🍞 "
style = "bold yellow"
format = "[$symbol($version)]($style) "

[python]
symbol = " "
style = "bold yellow"
format = "[$symbol($version)]($style) "

[rust]
symbol = " "
style = "bold red"
format = "[$symbol($version)]($style) "

[package]
symbol = "📦 "
style = "bold dimmed"
format = "[$symbol$version]($style) "

[time]
disabled = true
STARSHIP

success "Starship configured"

# ─── Kitty config ───────────────────────────
step "Kitty config"
mkdir -p "$HOME/.config/kitty"

cat > "$HOME/.config/kitty/kitty.conf" << 'KITTY'
# ─── Font ───────────────────────────────────
font_family      JetBrainsMono Nerd Font
bold_font        JetBrainsMono Nerd Font Bold
italic_font      JetBrainsMono Nerd Font Italic
bold_italic_font JetBrainsMono Nerd Font Bold Italic
font_size        14.0
adjust_line_height  110%
disable_ligatures never

# ─── Cursor ─────────────────────────────────
cursor_shape           block
cursor_blink_interval  0
cursor_stop_blinking_after 0

# ─── Scrollback ─────────────────────────────
scrollback_lines       10000
scrollback_pager_history_size 0

# ─── Mouse ──────────────────────────────────
mouse_hide_wait        2.0
copy_on_select         clipboard
strip_trailing_spaces  smart

# ─── Window ─────────────────────────────────
remember_window_size   yes
initial_window_width   220c
initial_window_height  50c
window_padding_width   12
placement_strategy     center
hide_window_decorations no
macos_titlebar_color    background
macos_option_as_alt     yes

# ─── Tabs ───────────────────────────────────
tab_bar_edge            bottom
tab_bar_style           powerline
tab_powerline_style     slanted
tab_title_template      "{index}: {title}"
active_tab_font_style   bold

# ─── Performance ────────────────────────────
repaint_delay     10
input_delay       3
sync_to_monitor   yes

# ─── Bell ───────────────────────────────────
enable_audio_bell no
visual_bell_duration 0.0

# ─── Shell ──────────────────────────────────
shell      /bin/zsh
editor     auto
close_on_child_death no

# ─── Keyboard shortcuts ─────────────────────
map cmd+t       new_tab_with_cwd
map cmd+w       close_tab
map cmd+]       next_tab
map cmd+[       previous_tab
map cmd+enter   new_window_with_cwd
map cmd+d       launch --location=vsplit --cwd=current
map cmd+shift+d launch --location=hsplit --cwd=current
map ctrl+cmd+f  toggle_fullscreen
map cmd+equal   change_font_size all +1.0
map cmd+minus   change_font_size all -1.0
map cmd+0       change_font_size all 0

# ─── Catppuccin Mocha theme ─────────────────
include catppuccin-mocha.conf
KITTY

# Catppuccin Mocha palette
cat > "$HOME/.config/kitty/catppuccin-mocha.conf" << 'CATPPUCCIN'
# Catppuccin Mocha
foreground              #CDD6F4
background              #1E1E2E
selection_foreground    #1E1E2E
selection_background    #F5C2E7

cursor                  #F5E0DC
cursor_text_color       #1E1E2E

url_color               #F5C2E7

active_tab_foreground   #11111B
active_tab_background   #CBA6F7
inactive_tab_foreground #CDD6F4
inactive_tab_background #181825
tab_bar_background      #11111B

active_border_color     #B4BEFE
inactive_border_color   #6C7086
bell_border_color       #F9E2AF

# black
color0  #45475A
color8  #585B70

# red
color1  #F38BA8
color9  #F38BA8

# green
color2  #A6E3A1
color10 #A6E3A1

# yellow
color3  #F9E2AF
color11 #F9E2AF

# blue
color4  #89B4FA
color12 #89B4FA

# magenta
color5  #F5C2E7
color13 #F5C2E7

# cyan
color6  #94E2D5
color14 #94E2D5

# white
color7  #BAC2DE
color15 #A6ADC8
CATPPUCCIN

success "Kitty configured with Catppuccin Mocha"

# ─── Claude CLI ─────────────────────────────
step "Claude CLI"
if ! command -v claude &>/dev/null; then
  info "Installing Claude CLI..."
  curl -fsSL https://claude.ai/install.sh | bash
  success "Claude CLI installed"
else
  success "Claude CLI already installed"
fi

# ─── Gen tool ───────────────────────────────
step "Gen image tool"
info "Installing gen..."
curl -fsSL https://raw.githubusercontent.com/Faeziix/gen/main/install.sh | bash
success "Gen installed"

# ─── Claude gen skill ───────────────────────
step "Claude gen skill"
if command -v claude &>/dev/null; then
  claude skill add gen 2>/dev/null || warn "Could not add gen skill — run 'claude skill add gen' manually after setup"
else
  warn "Claude not in PATH yet — run 'claude skill add gen' after restarting terminal"
fi

# ─── macOS defaults ─────────────────────────
step "macOS sensible defaults"

defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

success "macOS defaults applied"

# ─── Set zsh as default shell ────────────────
step "Default shell"
ZSH_PATH="$(which zsh)"
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
  info "Setting zsh as default shell..."
  chsh -s "$ZSH_PATH"
  success "Default shell set to zsh"
else
  success "zsh already default shell"
fi

# ─── Done ───────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN}${BOLD}  Setup complete!${RESET}"
echo -e "${GREEN}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${BOLD}Next steps:${RESET}"
echo -e "  1. Restart terminal / open Kitty"
echo -e "  2. Verify: ${YELLOW}claude --version${RESET}"
echo -e "  3. Auth: ${YELLOW}claude${RESET}"
echo ""
echo -e "  ${BOLD}Key aliases:${RESET}"
echo -e "  ${YELLOW}cc${RESET}    → claude"
echo -e "  ${YELLOW}work${RESET}  → cd ~/Work"
echo -e "  ${YELLOW}ll${RESET}    → lsd (pretty ls)"
echo -e "  ${YELLOW}cat${RESET}   → bat"
echo -e "  ${YELLOW}find${RESET}  → fd"
echo -e "  ${YELLOW}grep${RESET}  → ripgrep"
echo ""
echo -e "  ${BOLD}Kitty shortcuts:${RESET}"
echo -e "  ${YELLOW}cmd+t${RESET}         → new tab (cwd)"
echo -e "  ${YELLOW}cmd+d${RESET}         → vertical split"
echo -e "  ${YELLOW}cmd+shift+d${RESET}   → horizontal split"
echo -e "  ${YELLOW}cmd+] / cmd+[${RESET} → next/prev tab"
echo ""
