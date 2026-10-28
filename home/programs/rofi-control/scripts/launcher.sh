#!/usr/bin/env bash
# Control center: one menu that opens the other menus. The last four entries
# open this config's own existing menus (clipboard, emoji, wallpaper, session).
ROFI_DIR="$HOME/.config/rofi/control"
THEME="$ROFI_DIR/themes/presets/submenu.rasi"

choice=$(printf '%s\n' \
    "󰤨  WiFi" \
    "󰂯  Bluetooth" \
    "󰕾  Audio" \
    "󰎈  Music" \
    "󰍹  Monitor" \
    "  Keyboard Layout" \
    "󰆞  Screenshots" \
    "  Record Screen" \
    "  Clipboard" \
    "󰸉  Wallpaper" \
    "󰐥  Session" \
    | rofi -dmenu -theme "$THEME" -p "Control")

[[ -z "$choice" ]] && exit 0

case "$choice" in
    *"WiFi") exec bash "$ROFI_DIR/scripts/wifi.sh" ;;
    *"Bluetooth") exec bash "$ROFI_DIR/scripts/bluetooth.sh" ;;
    *"Audio") exec bash "$ROFI_DIR/scripts/audio.sh" ;;
    *"Music") exec bash "$ROFI_DIR/scripts/musicPlayer.sh" ;;
    *"Monitor") exec bash "$ROFI_DIR/scripts/monitor.sh" ;;
    *"Keyboard Layout") exec bash "$ROFI_DIR/scripts/kb-layout.sh" ;;
    *"Screenshots") exec bash "$ROFI_DIR/scripts/screenshots.sh" ;;
    *"Record Screen") exec bash "$ROFI_DIR/scripts/recordscreen.sh" ;;
    *"Clipboard") exec bash "$HOME/.config/rofi/menus/clipboard.sh" ;;
    *"Wallpaper") exec bash "$HOME/.config/rofi/menus/swww.sh" ;;
    *"Session") exec bash "$HOME/.config/hypr/scripts/power-menu.sh" ;;
esac
