#!/usr/bin/env bash

# Set ZSH home config
tee -a /etc/profile.d/98-ZSH-CONFIG-HOME.sh <<EOF
set ZDOTDIR=$XDG_CONFIG_HOME/zsh
EOF
