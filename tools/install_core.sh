#!/bin/bash

# ── Wayland / Compositor Stack ────────────────────────────────────────────────
WAYLAND_PKGS=(
    hyprland                        # Compositor
    hyprlock                        # Lock screen
    xdg-desktop-portal-hyprland    # XDG portal (screen share, file pickers)
    xdg-utils
    qt5-wayland
    qt6-wayland
    polkit-gnome                    # Auth agent
    grim                            # Screenshots
    slurp                           # Screen region selector
    wl-clipboard                    # Clipboard (wl-copy / wl-paste)
    cliphist                        # Clipboard history
)

# ── Bar & Notifications ───────────────────────────────────────────────────────
BAR_PKGS=(
    waybar                          # Status bar
    waybar-hyprland                 # Hyprland module for waybar
    mako                            # Notification daemon
    rofi-wayland                    # App launcher (Wayland-native fork)
    swww                            # Wallpaper daemon with smooth transitions
    python-pywal                    # Color scheme generator from wallpaper
    libinput                        # Touchpad/gesture support
    playerctl                       # Media player controls for waybar
    networkmanager                  # Network manager for waybar
    iproute2                        # Network info for waybar
    upower                          # Battery info for waybar
    pulseaudio                      # Audio for waybar
)

# ── Terminals & Shell ─────────────────────────────────────────────────────────
TERMINAL_PKGS=(
    alacritty                       # Primary terminal
    tmux                            # Terminal multiplexer
    zsh                             # Shell
    starship                        # Prompt
    fzf                             # Fuzzy finder
    ripgrep                         # Fast grep (rg)
    fd                              # Fast find
    bat                             # Cat with syntax highlighting
    eza                             # Modern ls
    htop                            # Process viewer
    btop                            # Better process viewer
    jq                              # JSON processor (used by wallpaper scripts)
    wget
    curl
    unzip
    zip
)

# ── System & File Management ──────────────────────────────────────────────────
SYSTEM_PKGS=(
    nautilus                        # File manager
    file-roller                     # Archive manager
    gvfs gvfs-mtp                   # Virtual file system (USB, MTP)
    network-manager-applet          # Network tray applet
    brightnessctl                   # Screen brightness control
    wdisplays                       # Display configuration GUI
    wlogout                         # Logout menu
)

# ── Fonts & Icons ─────────────────────────────────────────────────────────────
THEME_PKGS=(
    ttf-jetbrains-mono-nerd         # Primary coding font
    ttf-dejavu
    noto-fonts
    noto-fonts-emoji
    ttf-font-awesome                # Icons used in waybar
    papirus-icon-theme
    papirus-folders                 # Colored folder icons
    gtk3
    gtk4
    adwaita-icon-theme
)

ALL_PACMAN=(
    "${WAYLAND_PKGS[@]}"
    "${BAR_PKGS[@]}"
    "${TERMINAL_PKGS[@]}"
    "${SYSTEM_PKGS[@]}"
    "${THEME_PKGS[@]}"
)

echo -e "\033[0;36m[INFO]\033[0m Installing Core System Packages..."
sudo pacman -S --needed --noconfirm "${ALL_PACMAN[@]}"
echo -e "\033[0;32m[OK]\033[0m Core System Packages installed."
