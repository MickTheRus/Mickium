#!/usr/bin/env bash

clipboard=$(cliphist list)

selected=$(printf '%s\n' "$clipboard" | rofi -dmenu -theme "$HOME/.config/rofi/styles/clipboard.rasi" -p "󱘢" -display-columns 2)

if [[ $selected != "" ]]; then
    printf '%s\n' "$selected" | cliphist decode | wl-copy
fi
