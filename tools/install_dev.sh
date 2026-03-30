#!/bin/bash

# ── Development Tools ─────────────────────────────────────────────────────────
DEV_PKGS=(
    git
    neovim
    nodejs                          # Node.js runtime
    npm                             # Node package manager
    python
    python-pip
    php
    composer                        # PHP package manager
    docker
    docker-compose
    base-devel                      # Build tools (gcc, make, etc.)
)

AUR_DEV=(
    pnpm-bin                        # pnpm — fast Node package manager
)

echo -e "\033[0;36m[INFO]\033[0m Installing Development Packages..."
sudo pacman -S --needed --noconfirm "${DEV_PKGS[@]}"
yay -S --needed --noconfirm "${AUR_DEV[@]}"
echo -e "\033[0;32m[OK]\033[0m Dev Packages installed."
