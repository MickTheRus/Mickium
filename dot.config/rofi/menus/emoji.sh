#!/usr/bin/env bash

rofi -modi emoji -show emoji -theme "$HOME/.config/rofi/styles/emoji.rasi" -emoji-format '<span size="large">{emoji}</span> <span weight="bold">{name}</span> [<span size="small">({keywords})</span>]'
