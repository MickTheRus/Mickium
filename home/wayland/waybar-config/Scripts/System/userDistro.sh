#!/usr/bin/env bash

source /etc/os-release

case "$ID" in
    nixos)
        icon=""
        ;;

    arch)
        icon=""
        ;;

    artix)
        icon=""
        ;;

    manjaro)
        icon=""
        ;;

    endeavouros)
        icon=""
        ;;

    cachyos)
        icon=""
        ;;

    *)
        icon=""
        ;;
esac


kernel=$(uname -r)
USER=$(whoami)
tooltip="$icon  ${NAME}\n  ${kernel}\n  ${USER}"

printf '{"text":"%s","tooltip":"%s"}\n' "$icon" "$tooltip"
