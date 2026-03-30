#!/bin/bash
# #######################################################################################
# SETTINGS MENU — Rofi-based control panel
# Launch with:  SUPER + Shift + S
# #######################################################################################

SCRIPTS_DIR="$HOME/.config/scripts"

# ── Menu items ────────────────────────────────────────────────────────────────
OPTIONS=(
    "🖼  Wallpaper        Change & auto-theme"
    "🔒  Lock Screen      Hyprlock"
    "⏻   Power Menu       Shutdown / Reboot / Logout"
    "📶  Network          WiFi & connections"
    "🔊  Audio            Volume control"
    "🖥  Display          Monitor layout"
    "🎨  Reload Theme     Re-apply current theme"
    "📋  Clipboard        Clipboard history"
)

# ── Rofi theme overrides for settings ─────────────────────────────────────────
ROFI_THEME='
window    { width: 540px; }
listview  { lines: 8; }
element   { padding: 12px 16px; }
'

CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | \
    rofi -dmenu \
         -i \
         -p "  Settings" \
         -theme-str "$ROFI_THEME" \
         -selected-row 0)

[[ -z "$CHOICE" ]] && exit 0

# ── Handle selection ──────────────────────────────────────────────────────────
case "$CHOICE" in

    "🖼  Wallpaper"*)
        bash "$SCRIPTS_DIR/wallpaper.sh"
        ;;

    "🔒  Lock Screen"*)
        hyprlock
        ;;

    "⏻   Power Menu"*)
        bash "$SCRIPTS_DIR/powermenu.sh"
        ;;

    "📶  Network"*)
        # Open nmtui in a floating alacritty window
        alacritty \
            --class "float,float" \
            --option "window.dimensions.columns=80" \
            --option "window.dimensions.lines=28" \
            -e nmtui &
        ;;

    "🔊  Audio"*)
        if command -v pavucontrol &>/dev/null; then
            pavucontrol &
        else
            alacritty --class "float,float" -e pulsemixer &
        fi
        ;;

    "🖥  Display"*)
        if command -v wdisplays &>/dev/null; then
            wdisplays &
        else
            notify-send "Display" "wdisplays not installed" --expire-time=3000
        fi
        ;;

    "🎨  Reload Theme"*)
        # Re-run pywal on the last wallpaper
        LAST_WALL="$HOME/.cache/wal/wal"
        if [[ -f "$LAST_WALL" ]]; then
            bash "$SCRIPTS_DIR/wallpaper.sh" "$(cat "$LAST_WALL")"
        else
            notify-send "Theme" "No wallpaper set yet. Use 'Wallpaper' option first." --expire-time=4000
        fi
        ;;

    "📋  Clipboard"*)
        cliphist list | rofi -dmenu -p " Clipboard" | cliphist decode | wl-copy
        ;;

esac
