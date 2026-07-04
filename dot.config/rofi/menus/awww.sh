#!/usr/bin/env bash

# all wallpapers array
wallpaper_dir="$HOME/Pictures/Wallpapers"
shopt -s nullglob
wallpapers=("$wallpaper_dir"/*)

# getting the current wallpaper with `awww query`
current_wallpaper_path=$(awww query | sed "s/.*image: \(.*\)/\1/")

# if the daemon is not running
if [[ $current_wallpaper_path == "" ]]; then
    awww-daemon &
fi

current_wallpaper_name=$(basename "$current_wallpaper_path")

# show menu (with icon)
selected_wallpaper=$(for a in "${wallpapers[@]}"; do
    wallpaper_name=$(basename "$a")
    if [[ $wallpaper_name == "$current_wallpaper_name" ]]; then
        printf '%s (current)\0icon\x1f%s\n' "$wallpaper_name" "$a"
    else
        printf '%s\0icon\x1f%s\n' "$wallpaper_name" "$a"
    fi
done | rofi -dmenu -p " " -theme "$HOME/.config/rofi/styles/awww.rasi")

# removing the added " (current)" from the selected wallpaper (no matter the item selected)
final_wallpaper=$(printf '%s\n' "$selected_wallpaper" | sed "s/ (current)//")

# changing the wallpaper if selected wallpaper is not empty
if [[ $selected_wallpaper != "" ]]; then
    awww img "$wallpaper_dir/$final_wallpaper" --transition-type center --transition-fps 60 --transition-step 100 &&
    ln -sf "$wallpaper_dir/$final_wallpaper" "$HOME/.cache/current-wallpaper" && # creates a symlink to the current wallpaper
    "$HOME/.config/hypr/scripts/generate-wallpaper-variants.sh" # generates all the variants at a single time
fi
