#!/usr/bin/env bash

screen_size=$(xrandr | grep ' connected' | awk '{print $3}' | cut -f1 -d"+")

IFS=$'\n'
readarray -t <<<"$screen_size"
feh_command="feh --bg-fill"

for i in "${MAPFILE[@]}"
do
    feh_command="$feh_command ~/Mickium/misc/wall.jpg"
done

eval "$feh_command"
