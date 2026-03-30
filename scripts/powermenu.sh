#!/bin/bash
# #######################################################################################
# POWER MENU — Rofi-based
# Actions: Lock / Suspend / Logout / Reboot / Shutdown
# #######################################################################################

OPTIONS=(
    "  Lock"
    "  Suspend"
    "  Logout"
    "  Reboot"
    "  Shutdown"
)

ROFI_THEME='
window    { width: 360px; border-radius: 16px; }
listview  { lines: 5; }
element   { padding: 14px 20px; font-size: 15px; }
'

CHOICE=$(printf '%s\n' "${OPTIONS[@]}" | \
    rofi -dmenu \
         -i \
         -p " Power" \
         -theme-str "$ROFI_THEME" \
         -selected-row 2)

[[ -z "$CHOICE" ]] && exit 0

confirm() {
    echo -e "  Yes\n  No" | \
        rofi -dmenu -p "Confirm $1?" \
             -theme-str 'window{width:280px;} listview{lines:2;}' | \
        grep -q "Yes"
}

case "$CHOICE" in
    "  Lock")      hyprlock ;;
    "  Suspend")   confirm "Suspend"  && systemctl suspend ;;
    "  Logout")    confirm "Logout"   && hyprctl dispatch exit ;;
    "  Reboot")    confirm "Reboot"   && systemctl reboot ;;
    "  Shutdown")  confirm "Shutdown" && systemctl poweroff ;;
esac
