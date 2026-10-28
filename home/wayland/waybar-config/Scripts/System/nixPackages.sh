#!/usr/bin/env bash
# Nix package counts, replacing BlackNode's pacman/AUR update counters.
# system = packages in the system profile (and everything they depend on),
# user   = packages in your user profile (Home Manager) the same way.
sys=$(nix-store -q --requisites /run/current-system/sw 2>/dev/null | wc -l)
usr=$(nix-store -q --requisites "/etc/profiles/per-user/$(whoami)" 2>/dev/null | wc -l)
all=$(nix-store -q --requisites /run/current-system 2>/dev/null | wc -l)

tip="Nix packages (store paths)\nSystem profile: $sys\nUser profile: $usr\nWhole system closure: $all"
jq -nc --arg t "󰏖  $sys  󰀄  $usr" --arg tip "$(printf '%b' "$tip")" '{text:$t,class:"packages",tooltip:$tip}'
