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
