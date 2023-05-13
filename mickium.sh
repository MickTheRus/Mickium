#!/usr/bin/env bash

# Get current working directory
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

sudo bash "$SCRIPT_DIR/scripts/0-packages.sh"
bash "$SCRIPT_DIR/scripts/1-user_stuff.sh"
bash "$SCRIPT_DIR/scripts/2-set-enviroment-variables.sh"
bash "$SCRIPT_DIR/scripts/getnf"
