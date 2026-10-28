#!/usr/bin/env bash
# Do Not Disturb toggle for SwayNC (BlackNode's original used dunst).

status() {
    if [ "$(swaync-client -D 2>/dev/null)" = "true" ]; then
        printf '{"text":"󰂛","class":"dnd-active","tooltip":"Do Not Disturb: On"}\n'
    else
        printf '{"text":"󰂚","class":"dnd-inactive","tooltip":"Do Not Disturb: Off"}\n'
    fi
}

case "$1" in
    toggle) swaync-client -d >/dev/null ;;
    *) status ;;
esac
