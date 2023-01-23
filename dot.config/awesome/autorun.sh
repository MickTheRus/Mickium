#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "picom"
run "unclutter"
run "discord"
run "nm-applet"
run "/usr/bin/lxsession"

killall -q polybar
polybar left &
polybar right &
polybar middle &
