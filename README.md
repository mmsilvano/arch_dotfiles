# 🌑 Arch Dotfiles

Minimal, dark, glassmorphism Hyprland setup for Arch Linux / CachyOS.

## Stack

| Component | App |
|-----------|-----|
| WM | Hyprland |
| Bar | Waybar |
| Terminal | Alacritty |
| Launcher | Rofi (Wayland) |
| Notifications | Mako |
| Editor | Neovim (Kickstart) |
| Shell | Zsh + Starship |
| File Manager | Nautilus |
| Browser | Brave / Firefox / Chrome |

## Install

```bash
git clone https://github.com/youruser/arch_dotfiles ~/.dotfiles
cd ~/.dotfiles
bash install.sh
```

The script will:
- Install `yay` if not present
- Install all packages (pacman + AUR)
- Symlink configs to `~/.config/`
- Setup Docker + add user to docker group
- Setup Zsh + Starship prompt
- Create Antigravity PWA shortcut

After install:
1. **Re-login** (docker group + shell change)
2. Run `nvim` — lazy.nvim bootstraps and installs all plugins automatically
3. Add wallpaper to `~/Pictures/Wallpapers/wallpaper.jpg`

## Keybindings

### Workspace
| Binding | Action |
|---------|--------|
| `SUPER + 1…9` | Switch to workspace (dynamic) |
| `ALT + q,w,e,r,t,y` | Move active window → workspace 1–6 |
| `SUPER + Tab` | Next workspace |
| `SUPER + Shift + Tab` | Prev workspace |

### App Launchers
| Binding | App |
|---------|-----|
| `SUPER + Return` | Alacritty |
| `SUPER + B` | Brave |
| `SUPER + E` | Nautilus |
| `SUPER + \`` | Rofi launcher (grave) |
| `SUPER + Shift + S` | Settings / Wallpaper menu |
| `ALT + 1` | Brave |
| `ALT + 2` | Alacritty |
| `ALT + 3` | Nautilus |

### Window
| Binding | Action |
|---------|--------|
| `SUPER + Q` | Close window |
| `SUPER + F` | Fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + M` | Scratchpad toggle |
| `SUPER + Shift + M` | Move to scratchpad |
| `Print` | Screenshot (select area → clipboard) |
| `Shift + Print` | Screenshot → save to ~/Pictures |

### Neovim Leader Keys (`Space`)
| Binding | Action |
|---------|--------|
| `<leader>e` | File tree (Neo-tree) |
| `<leader>sf` | Find files (Telescope) |
| `<leader>sg` | Live grep |
| `<leader>f` | Format buffer |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>la` | Laravel Artisan |
| `<leader>lr` | Laravel Routes |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover docs |
| `Ctrl+\` | Float terminal |

## Structure

```
arch_dotfiles/
├── hypr/
│   └── hyprland.conf
├── waybar/
│   ├── config
│   └── style.css
├── rofi/
│   └── config.rasi
├── alacritty/
│   ├── alacritty.toml
│   └── themes/dark.toml
├── nvim/
│   └── init.lua          ← Kickstart-based, auto-installs plugins
├── mako/
│   └── config
├── hyprlock/
└── install.sh
```
