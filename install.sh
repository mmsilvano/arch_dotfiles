#!/bin/bash

# #######################################################################################
# HYPRLAND DOTFILES INSTALLER — Arch Linux / CachyOS
# #######################################################################################

set -e

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }
step()    { echo -e "\n${BOLD}${BLUE}══════════════════════════════════════\n  $*\n══════════════════════════════════════${NC}"; }

# ── Sanity check ──────────────────────────────────────────────────────────────
command -v pacman &>/dev/null || error "Only Arch Linux / CachyOS (pacman) is supported."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# #######################################################################################
# STEP 1 — AUR Helper (yay)
# #######################################################################################
step "AUR Helper — yay"

if ! command -v yay &>/dev/null; then
    info "Installing build dependencies..."
    sudo pacman -S --needed --noconfirm git base-devel

    info "Cloning and building yay..."
    TMPDIR_YAY="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$TMPDIR_YAY"
    (cd "$TMPDIR_YAY" && makepkg -si --noconfirm)
    rm -rf "$TMPDIR_YAY"
    success "yay installed."
else
    success "yay already present — $(yay --version | head -1)"
fi

# #######################################################################################
# STEP 2 — Core System & Wayland Stack
# #######################################################################################
step "Core System & Wayland"
bash "$DOTFILES_DIR/tools/install_core.sh"

# #######################################################################################
# STEP 3 — Development Tools & Runtimes
# #######################################################################################
step "Development Tools"
bash "$DOTFILES_DIR/tools/install_dev.sh"

# #######################################################################################
# STEP 4 — Browsers & Media
# #######################################################################################
step "Browsers & Media"
bash "$DOTFILES_DIR/tools/install_browsers.sh"
bash "$DOTFILES_DIR/tools/install_media.sh"

# #######################################################################################
# STEP 5 — Extra AUR Utilities
# #######################################################################################
step "Extra AUR Utilities"
bash "$DOTFILES_DIR/tools/install_aur_tools.sh"

# #######################################################################################
# STEP 6 — pnpm & Node Tools setup
# #######################################################################################
step "pnpm & Node Tools"
bash "$DOTFILES_DIR/tools/install_node_tools.sh"

# #######################################################################################
# STEP 7 — Docker Setup
# #######################################################################################
step "Docker"
bash "$DOTFILES_DIR/tools/setup_docker.sh"

# #######################################################################################
# STEP 8 — Dotfile Symlinks
# #######################################################################################
step "Symlinking Dotfiles → ~/.config"

SYMLINK_DIRS=(hypr waybar rofi hyprlock mako alacritty nvim wal scripts)

for dir in "${SYMLINK_DIRS[@]}"; do
    SOURCE="$DOTFILES_DIR/$dir"
    TARGET="$CONFIG_DIR/$dir"
    BACKUP="$TARGET.bak.$(date +%F_%T)"

    if [ ! -d "$SOURCE" ]; then
        warn "Source $SOURCE not found — skipping."
        continue
    fi

    if [ -d "$TARGET" ] || [ -f "$TARGET" ] || [ -L "$TARGET" ]; then
        info "Backing up existing $dir → $BACKUP"
        mv "$TARGET" "$BACKUP"
    fi

    info "Linking $dir..."
    ln -sf "$SOURCE" "$TARGET"
    success "$dir  →  $TARGET"
done

# Make scripts executable
chmod +x "$DOTFILES_DIR"/scripts/*.sh 2>/dev/null || true

# #######################################################################################
# STEP 9 — Neovim Plugin Bootstrap
# #######################################################################################
step "Neovim — Kickstart Config"

NVIM_CFG="$CONFIG_DIR/nvim"
if [ -L "$NVIM_CFG" ]; then
    info "nvim config symlinked. Plugins auto-install on first launch via lazy.nvim."
    info "Run 'nvim' to trigger the bootstrap."
else
    warn "nvim config symlink not found — check step 6."
fi

# #######################################################################################
# STEP 10 — Shell — Zsh + Starship + tmux
# #######################################################################################
step "Shell — Zsh + Starship + tmux"

# Change default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Changing default shell to zsh..."
    chsh -s "$(which zsh)" "$USER"
    success "Default shell → zsh (re-login to activate)"
else
    success "zsh already the default shell."
fi

# Starship config
STARSHIP_CFG="$HOME/.config/starship.toml"
if [ ! -f "$STARSHIP_CFG" ]; then
    info "Generating starship prompt config..."
    mkdir -p "$HOME/.config"
    cat > "$STARSHIP_CFG" << 'STARSHIP'
"$schema" = 'https://starship.rs/config-schema.json'

format = """
[](fg:#a3aed2)\
[ 󰣇 ](bg:#a3aed2 fg:#090c0c)\
[](fg:#a3aed2 bg:#769ff0)\
$directory\
[](fg:#769ff0 bg:#394260)\
$git_branch\
$git_status\
[](fg:#394260 bg:#212736)\
$nodejs\
$php\
[](fg:#212736 bg:#1d2230)\
$time\
[ ](fg:#1d2230)\
\n$character"""

[directory]
style = "fg:#e3e5e5 bg:#769ff0"
format = "[ $path ]($style)"
truncation_length = 3
truncate_to_repo  = false

[git_branch]
symbol = ""
style  = "bg:#394260"
format = '[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)'

[git_status]
style  = "bg:#394260"
format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)'

[nodejs]
symbol = ""
style  = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

[php]
symbol = ""
style  = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

[time]
disabled    = false
time_format = "%R"
style       = "bg:#1d2230"
format      = '[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)'
STARSHIP
    success "Starship config created."
fi

# .zshrc configuration
ZSHRC="$HOME/.zshrc"
if ! grep -q "# dotfiles-managed" "$ZSHRC" 2>/dev/null; then
    cat >> "$ZSHRC" << 'ZSH'

# ── dotfiles-managed ────────────────────────────────────────────────────────

# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias ls='eza --icons --color=auto'
alias ll='eza -la --icons --git'
alias lt='eza --tree --icons --level=2'
alias la='eza -a --icons'
alias cat='bat --paging=never'
alias vim='nvim'
alias vi='nvim'
alias gc='git commit'
alias gs='git status'
alias gp='git push'
alias gl='git log --oneline --graph'
alias dps='docker ps'
alias dco='docker compose'

# FZF
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# pywal colors in terminal (optional - uncomment to enable)
# (cat ~/.cache/wal/sequences &)

# tmux autostart in login shells
# Uncomment to auto-start tmux on terminal open:
# [[ -z "$TMUX" && "$TERM_PROGRAM" != "vscode" ]] && tmux new-session -A -s main
ZSH
    success "Shell config appended to .zshrc"
else
    success ".zshrc already configured."
fi

# tmux config
TMUX_CFG="$HOME/.tmux.conf"
if [ ! -f "$TMUX_CFG" ]; then
    info "Creating tmux config..."
    cat > "$TMUX_CFG" << 'TMUX'
# ── tmux.conf ───────────────────────────────────────────────────────────────
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",alacritty:RGB"
set -g prefix C-a
unbind C-b
bind C-a send-prefix

set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g mouse on
set -g history-limit 10000

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Split panes
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Status bar
set -g status-style "bg=#0d0d0d fg=#909090"
set -g status-left "#[fg=#7aa2f7,bold] #S "
set -g status-right "#[fg=#7aa2f7] %H:%M #[fg=#9ece6a]%d %b "
set -g window-status-current-style "fg=#7aa2f7,bold"
set -g pane-border-style "fg=#3a3a3a"
set -g pane-active-border-style "fg=#7aa2f7"
set -g message-style "bg=#7aa2f7 fg=#0d0d0d"
TMUX
    success "tmux config created."
fi

# #######################################################################################
# STEP 11 — Wallpaper Directory & swww init
# #######################################################################################
step "Wallpaper Setup"

WALLS_DIR="$HOME/Pictures/Wallpapers"
mkdir -p "$WALLS_DIR"

# Generate a default pywal-colors.css so waybar starts without error
WAL_CSS="$DOTFILES_DIR/waybar/pywal-colors.css"
if [ ! -f "$WAL_CSS" ]; then
    info "Creating default pywal-colors.css fallback..."
    cat > "$WAL_CSS" << 'WALCSS'
/* pywal generated colors — overwritten by scripts/wallpaper.sh */
* {
    --wal-bg:     #0d0d0d;
    --wal-fg:     #f0f0f0;
    --wal-color0: #0d0d0d;
    --wal-color1: #e06c75;
    --wal-color2: #98c379;
    --wal-color3: #e5c07b;
    --wal-color4: #61afef;
    --wal-color5: #c678dd;
    --wal-color6: #56b6c2;
    --wal-color7: #abb2bf;
    --wal-accent: #61afef;
}
WALCSS
    success "pywal-colors.css defaults created."
fi

ALAC_TOML="$DOTFILES_DIR/alacritty/themes/pywal.toml"
if [ ! -f "$ALAC_TOML" ]; then
    info "Creating default pywal.toml fallback for Alacritty..."
    cat > "$ALAC_TOML" << 'ALACTOML'
# pywal generated fallback
[colors.primary]
  background = "#0d0d0d"
  foreground = "#f0f0f0"

[colors.cursor]
  text   = "#0d0d0d"
  cursor = "#f0f0f0"

[colors.normal]
  black   = "#0d0d0d"
  red     = "#e06c75"
  green   = "#98c379"
  yellow  = "#e5c07b"
  blue    = "#61afef"
  magenta = "#c678dd"
  cyan    = "#56b6c2"
  white   = "#abb2bf"

[colors.bright]
  black   = "#7a7a7a"
  red     = "#e06c75"
  green   = "#98c379"
  yellow  = "#e5c07b"
  blue    = "#61afef"
  magenta = "#c678dd"
  cyan    = "#56b6c2"
  white   = "#ffffff"
ALACTOML
    success "pywal.toml defaults created."
fi

# #######################################################################################
# STEP 12 — Antigravity PWA
# #######################################################################################
step "Antigravity (Google)"

mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/antigravity.desktop" << 'DESKTOP'
[Desktop Entry]
Version=1.0
Name=Antigravity
Comment=Google Antigravity — https://antigravity.google/
Exec=brave --app=https://antigravity.google/ --class=Antigravity
Icon=google-chrome
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=Antigravity
StartupNotify=true
DESKTOP
update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
success "Antigravity PWA shortcut created (pinned to rofi app list)."

# #######################################################################################
# STEP 13 — .gitignore for generated files
# #######################################################################################
step "Git — Ignore generated files"

GITIGNORE="$DOTFILES_DIR/.gitignore"
cat > "$GITIGNORE" << 'GITIGNORE'
# pywal generated — overwritten at runtime
waybar/pywal-colors.css
alacritty/themes/pywal.toml

# OS
.DS_Store
Thumbs.db
*.swp
*.swo
GITIGNORE
success ".gitignore updated."

# #######################################################################################
# DONE
# #######################################################################################
step "Installation Complete! 🎉"
echo -e "
${BOLD}Key Bindings (Quick Reference):${NC}

  ${CYAN}SUPER + Space${NC}       → Rofi app launcher / search
  ${CYAN}SUPER + Return${NC}      → Alacritty terminal
  ${CYAN}SUPER + B${NC}           → Brave browser
  ${CYAN}SUPER + E${NC}           → Nautilus file manager
  ${CYAN}SUPER + Shift + S${NC}   → Settings / wallpaper menu
  ${CYAN}SUPER + 1–9${NC}         → Switch workspace (dynamic)
  ${CYAN}ALT + q,w,e,r,t,y${NC}  → Move window → workspace 1–6
  ${CYAN}ALT + 1/2/3${NC}         → Launch Brave / Alacritty / Nautilus
  ${CYAN}Print${NC}               → Screenshot (select region → clipboard)
  ${CYAN}Ctrl+\\${NC}             → Float terminal (tmux)

${BOLD}Next Steps:${NC}
  1. ${YELLOW}Re-login${NC} — docker group + zsh take effect
  2. Run ${CYAN}nvim${NC} — plugins auto-install via lazy.nvim
  3. Add wallpapers to ${CYAN}~/Pictures/Wallpapers/${NC}
  4. Run ${CYAN}~/.config/scripts/wallpaper.sh${NC} to pick a wallpaper + auto-theme
  5. Launch Antigravity from rofi (search: Antigravity)

${BOLD}${GREEN}Your setup is ready. Log out and back in!${NC}
"
