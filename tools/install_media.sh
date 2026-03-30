#!/bin/bash

# ── Media & Entertainment ─────────────────────────────────────────────────────
MEDIA_PKGS=(
    vlc
    mpv                             # Lightweight video player
    imv                             # Image viewer (Wayland-native)
    pavucontrol                     # PulseAudio/PipeWire volume control
    playerctl                       # Media player control (CLI)
)

AUR_MEDIA=(
    spotify                         # Spotify music player
)

echo -e "\033[0;36m[INFO]\033[0m Installing Media Packages..."
sudo pacman -S --needed --noconfirm "${MEDIA_PKGS[@]}"
yay -S --needed --noconfirm "${AUR_MEDIA[@]}"
echo -e "\033[0;32m[OK]\033[0m Media Packages installed."
