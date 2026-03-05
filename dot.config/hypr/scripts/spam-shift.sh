#!/bin/bash

# spam shift every 10ms
while true; do
    ydotool key 42:1      # Shift down
    ydotool key 42:0      # Shift up
    sleep 0.01            # 10 milliseconds
done
