#!/bin/bash

# #######################################################################################
# MINIMAL HYPRLAND DOTFILES INSTALLER
# #######################################################################################

set -e

# Detect Package Manager
if command -v pacman >/dev/null; then
    INSTALL_CMD="sudo pacman -S --needed --noconfirm"
else
    echo "Error: Only Arch/CachyOS (pacman) is supported by this script."
    exit 1
fi

# Define Dependencies
DEPS=(
    hyprland
    waybar
    wofi
    hyprlock
    mako
    kitty
    brave
    rofi
    papirus-icon-theme
    ttf-dejavu
)

echo "--- Installing Dependencies ---"
$INSTALL_CMD "${DEPS[@]}"

# Configuration Directory
CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$(pwd)"

# Setup Directories and Backups
echo "--- Setting up Configurations ---"
for dir in hypr waybar rofi hyprlock mako; do
    TARGET="$CONFIG_DIR/$dir"
    BACKUP="$TARGET.bak.$(date +%F_%T)"

    if [ -d "$TARGET" ] || [ -f "$TARGET" ]; then
        echo "Backing up existing $dir config to $BACKUP"
        mv "$TARGET" "$BACKUP"
    fi

    echo "Symlinking $dir..."
    ln -sf "$DOTFILES_DIR/$dir" "$TARGET"
done

echo "--- Installation Complete ---"
echo "Minimal monochrome dotfiles have been installed."
echo "Press SUPER + Return to open Kitty, and SUPER + B for Brave."
