# Minimal Monochrome Hyprland Dotfiles

An ultra-minimal, high-performance, and developer-focused Hyprland setup. No clutter, no distractions, just cold monochrome efficiency.

## Philosophy
- **Zero Bloat**: Only the essentials. No CPU/RAM modules, no tray, no window titles.
- **Sleek Monochrome**: A clean white-on-black aesthetic with subtle transparencies and blurs.
- **Speed**: Optimized animations for a snappy, responsive feel.
- **Security**: Minimal surface area with a clean lock screen.

## Prerequisites
- **OS**: Arch Linux or CachyOS.
- **Package Manager**: `pacman`.

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/projects/arch_dotfiles
   cd ~/projects/arch_dotfiles
   ```

2. Run the installer:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

The script will install dependencies (Hyprland, Waybar, Wofi, etc.), backup your existing configs, and symlink the new ones.

## Keybinds

| Keybind | Action |
| --- | --- |
| `SUPER + T` | Open Kitty Terminal |
| `SUPER + B` | Open Brave Browser |
| `SUPER + E` | Open Neovim (in Kitty) |
| `SUPER + P` | Open Rofi Spotlight |
| `SUPER + Q` | Kill Active Window |
| `SUPER + V` | Toggle Floating |
| `SUPER + F` | Fullscreen |
| `SUPER + 1-3` | Switch Workspace |
| `SUPER + SHIFT + 1-3` | Move Window to Workspace |

## Customization

### Changing Clock Format
Edit `~/.config/waybar/config`:
```json
"clock": {
    "format": "{:%A %-d}" // Thursday 4
}
```

### Modifying Theme
The monochrome theme is primarily controlled in:
- `~/.config/hypr/hyprland.conf`: Borders and gaps.
- `~/.config/waybar/style.css`: Bar appearance.
- `~/.config/rofi/config.rasi`: Launcher appearance (Spotlight style).

## Uninstallation
The installer creates backups with a `.bak` extension. To revert, simply delete the symlinks and rename the backups:
```bash
rm -rf ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/.config/hyprlock ~/.config/mako
mv ~/.config/hypr.bak.<timestamp> ~/.config/hypr
# ... repeat for other modules
```

---
*Stay focused. Stay minimal.*
