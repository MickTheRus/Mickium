#!/usr/bin/env bash

# XDG Base Directories
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_CACHE_HOME="$HOME"/.cache

# Bash History File
export HISTFILE=/dev/null

# Rust's Cargo 
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# GNU PG 
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# GNU Realine
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

export EDITOR="emacs -nw"
export VISUAL="emacs -nw"

export PATH="$PATH:$CARGO_HOME/bin"
