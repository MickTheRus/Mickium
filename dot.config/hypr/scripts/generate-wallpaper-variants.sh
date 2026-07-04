#!/usr/bin/env bash
set -euo pipefail

###############################
########## WLOGOUT ############
###############################
magick "$HOME/.cache/current-wallpaper" -scale 75% "$HOME/.cache/temp"
magick "$HOME/.cache/temp" -fill black -colorize 50% "$HOME/.cache/wlogout-background"
magick "$HOME/.cache/wlogout-background" -blur 0x10 "$HOME/.cache/wlogout-background"
rm "$HOME/.cache/temp"
