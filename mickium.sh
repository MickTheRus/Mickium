#!/bin/bash

# Just gets the directory of the script location
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

sudo bash "$SCRIPT_DIR/scripts/0-packages.sh"
bash "$SCRIPT_DIR/scripts/1-user_stuff.sh"
