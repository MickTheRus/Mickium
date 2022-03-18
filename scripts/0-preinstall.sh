#!/bin/bash
if [ -f setup.conf ]; then
  while true; do
    read -p "Do you want to use the existing setup file? " yn 
    case $yn in
      [Yy]* ) exit;;
      [Nn]* ) break;;
      * ) echo "Answer Y(yes) and N(no)";;
    esac
  done
fi

CONFIG_FILE=$CONFIGS_DIR/setup.conf
if [ ! -f $CONFIG_FILE ]; then 
    touch -f $CONFIG_FILE 
fi

set_option() {
    if grep -Eq "^${1}.*" $CONFIG_FILE; then 
        sed -i -e "/^${1}.*/d" $CONFIG_FILE 
    fi
    echo "${1}=${2}" >>$CONFIG_FILE 
}




