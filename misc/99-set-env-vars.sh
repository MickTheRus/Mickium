#!/usr/bin/env

# XDG Base Directories
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_STATE_HOME="$HOME"/.local/state 
export XDG_CACHE_HOME="$HOME"/.cache

# XDG Desktop
export XDG_CURRENT_DESKTOP="awesome"

# Bash History File
export HISTFILE=/dev/null

# Rust's Cargo 
export CARGO_HOME="$XDG_DATA_HOME"/cargo

# GNU PG 
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# GNU Realine
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

# X11 Error File
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

# Xauthority
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority

# ZSH config File
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
