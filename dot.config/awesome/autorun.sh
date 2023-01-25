#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}


run "flameshot 2> /dev/null"
run "picom"
run "discord"
run "nm-applet"
run "/usr/bin/lxsession"
