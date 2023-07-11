#!/bin/bash

# Get the Hyprland Instance Signature
HIS=$(echo $HYPRLAND_INSTANCE_SIGNATURE)

# Function to handle events
handle_event() {
  event=$1
  case $event in
    monitoradded*)
      # Extract the monitor identifier from the event
      monitor_id=$(echo $event | cut -d'>' -f3)
      # Find the line number of the placeholder
      line_num=$(grep -n "# Monitor configuration placeholder" ~/.config/hypr/hyprland.conf | cut -d: -f1)
      # Increment the line number to get the line below the placeholder
      line_num=$((line_num+1))
      # Add the variable declaration below the placeholder and append "#autoconf"
      sed -i "${line_num}i \$ext_monitor=$monitor_id #autoconf" ~/.config/hypr/hyprland.conf
      ;;
    monitorremoved*)
      # Remove the line with "#autoconf"
      sed -i "/#autoconf/d" ~/.config/hypr/hyprland.conf
      ;;
  esac
}

# Listen for events from the Hyprland UNIX socket
socat -U - UNIX-CONNECT:/tmp/hypr/$HIS/.socket2.sock | while read -r line; do handle_event "$line"; done

