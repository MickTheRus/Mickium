#!/usr/bin/env bash
ROFI_DIR="$HOME/.config/rofi/control"
THEME="$ROFI_DIR/themes/presets/submenu-bottom.rasi"

music_menu() {
    if ! playerctl status &>/dev/null; then
        notify-send "Music" "No player running"
        exec bash "$ROFI_DIR/scripts/launcher.sh"
    fi

    local play_icon play_label
    if [[ "$(playerctl status)" == "Playing" ]]; then
        play_icon="󰏤"
        play_label="Pause"
    else
        play_icon=""
        play_label="Play"
    fi

    local choice
    choice=$(printf '%s\n' \
        "󰒮  Previous" \
        "${play_icon}  ${play_label}" \
        "󰒭  Next" \
        "󰒝  Shuffle" \
        | rofi -dmenu -theme "$THEME" -p "Music" -l 4 -theme-str 'window {width: 49%;}')

    case "$choice" in
        *"Pause"|*"Play")  playerctl play-pause; music_menu ;;
        *"Next")           playerctl next; music_menu ;;
        *"Previous")       playerctl previous; music_menu ;;
        *"Shuffle")        playerctl shuffle toggle; music_menu ;;
    esac
}

music_menu
