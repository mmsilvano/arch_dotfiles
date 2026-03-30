#!/bin/bash

# ── Browsers ──────────────────────────────────────────────────────────────────
BROWSER_PKGS=(
    firefox                         # Firefox (official repo)
)

AUR_BROWSERS=(
    brave-bin                       # Brave browser
    google-chrome                   # Google Chrome
)

echo -e "\033[0;36m[INFO]\033[0m Installing Browsers..."
sudo pacman -S --needed --noconfirm "${BROWSER_PKGS[@]}"
yay -S --needed --noconfirm "${AUR_BROWSERS[@]}"
echo -e "\033[0;32m[OK]\033[0m Browser Packages installed."
