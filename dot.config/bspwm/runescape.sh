#!/bin/bash 
# Due to me not being good enough with BSPWM, alt1 toolkit requires to be tiled 

bspc config top_padding 0
pkill polybar
bspc config border_width         0 
bspc config window_gap           0
