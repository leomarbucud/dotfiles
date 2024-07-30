#!/bin/bash


dunstify -u low -h string:x-dunst-stack-tag:lockscreen "Updating lockscreen..." -t 30000

WALLPAPER=$(awk '/^\[xin_0\]/{f=1} f==1&&/^file/{print $1;exit}' ~/.config/nitrogen/bg-saved.cfg | sed '/^file=/{s/^file=//;}')
betterlockscreen -u $WALLPAPER --display DP-0

dunstify -u low -h string:x-dunst-stack-tag:lockscreen "Lockscreen updated!" -t 2000
