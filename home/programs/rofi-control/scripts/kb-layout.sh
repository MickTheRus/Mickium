#!/usr/bin/env bash
# Lists the layouts configured in Hyprland (kb_layout) and switches between them.
ROFI_DIR="$HOME/.config/rofi/control"
THEME="$ROFI_DIR/themes/presets/submenu.rasi"

DEVICE=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .name')

name_of() {
    case "$1" in
        us) echo "English" ;;
        ru) echo "Русский" ;;
        *)  echo "$1" ;;
    esac
}

layout_menu() {
    local layouts current input choice i
    IFS=, read -ra layouts < <(hyprctl devices -j | jq -r --arg dev "$DEVICE" '.keyboards[] | select(.name == $dev) | .layout')
    current=$(hyprctl devices -j | jq -r --arg dev "$DEVICE" '.keyboards[] | select(.name == $dev) | .active_keymap')

    input="󰌍  Back"$'\n'
    for i in "${!layouts[@]}"; do
        input+="  $(name_of "${layouts[i]}")"$'\n'
    done

    choice=$(printf '%s' "$input" | rofi -dmenu -theme "$THEME" -p "Layout ($current)" -format i)
    [[ -z "$choice" ]] && return
    [[ "$choice" -eq 0 ]] && exec bash "$ROFI_DIR/scripts/launcher.sh"

    hyprctl switchxkblayout "$DEVICE" $((choice - 1)) >/dev/null
}

layout_menu
