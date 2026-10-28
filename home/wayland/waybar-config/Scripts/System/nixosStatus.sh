#!/usr/bin/env bash
# Shows the system generation and whether a reboot is needed (the kernel of the
# running system differs from the booted one).
gen=$(readlink /nix/var/nix/profiles/system | sed -E 's/^system-([0-9]+)-link$/\1/')
booted=$(readlink /run/booted-system/kernel)
current=$(readlink /run/current-system/kernel)

if [ "$booted" != "$current" ]; then
  cls=reboot
  tip="NixOS generation $gen\nReboot needed: a newer kernel is staged"
else
  cls=ok
  tip="NixOS generation $gen\nUp to date"
fi

jq -nc --arg c "$cls" --arg t "$(printf '%b' "$tip")" '{text:"󱄅",class:$c,tooltip:$t}'
