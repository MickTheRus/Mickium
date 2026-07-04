#!/usr/bin/env bash

# changing the red color of terminal because generated palettes can make it too dark

__hex2rgb() {
    local hex=$1

    if [[ "#" == "${hex:0:1}" ]]; then
        hex="${hex:1:6}"
    fi

    local hex_r="${hex:0:2}"
    local hex_g="${hex:2:2}"
    local hex_b="${hex:4:2}"

    local rgb_r=$((16#$hex_r))
    local rgb_g=$((16#$hex_g))
    local rgb_b=$((16#$hex_b))

    echo "$rgb_r $rgb_g $rgb_b"
}

__rgb2hex() {
    local rgb_r=$1
    local rgb_g=$2
    local rgb_b=$3

    printf '#%02x%02x%02x\n' "$rgb_r" "$rgb_g" "$rgb_b"
}

__mix() { # will take 2 hex values and return the mixture in hex
    local rgb1 rgb2 rgb
    read -r -a rgb1 <<< "$(__hex2rgb "$1")"
    read -r -a rgb2 <<< "$(__hex2rgb "$2")"

    rgb=()

    for a in 0 1 2; do
        rgb[$a]=$(((rgb1[$a] + rgb2[$a]) / 2))
    done

    local hex
    hex=$(__rgb2hex "${rgb[@]}")

    echo "$hex"
}

colors_file="${XDG_CONFIG_HOME:-$HOME/.config}/kitty/colors.conf"

if [[ ! -f "$colors_file" ]]; then
    echo "Kitty colors file not found: $colors_file"
    exit 0
fi

palette_red1=$(grep "color1 " "$colors_file" | sed "s/.*\(#.*\)/\1/g")
palette_red2=$(grep "color9 " "$colors_file" | sed "s/.*\(#.*\)/\1/g")

my_red=#f7768e # TokyoNight red color

custom_red1=$(__mix "$palette_red1" "$(__mix "$palette_red1" "$my_red")")
custom_red2=$(__mix "$palette_red2" "$(__mix "$palette_red2" "$my_red")")

sed -i "s/$palette_red1/$custom_red1/g" "$colors_file"
sed -i "s/$palette_red2/$custom_red2/g" "$colors_file"

pgrep kitty | xargs -r kill -SIGUSR1

echo "$palette_red1 * 2 + $my_red = $custom_red1"
echo "$palette_red2 * 2 + $my_red = $custom_red2"
