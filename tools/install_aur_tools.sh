#!/bin/bash

# ── Apps (AUR) ────────────────────────────────────────────────────────────────
AUR_APPS=(
    hyprpicker                      # Color picker for Hyprland
    swayosd-git                     # OSD for volume/brightness
    nwg-look                        # GTK theme switcher for Wayland
    bibata-cursor-theme             # Modern cursor theme
)

echo -e "\033[0;36m[INFO]\033[0m Installing extra AUR Utilities..."
yay -S --needed --noconfirm "${AUR_APPS[@]}"
echo -e "\033[0;32m[OK]\033[0m AUR Utilities installed."
