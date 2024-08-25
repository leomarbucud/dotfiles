#!/bin/bash

dunstify -u low -h string:x-dunst-stack-tag:lockscreen "Updating lockscreen..." -t 60000

WALLPAPER1=$(awk '/^\[xin_0\]/{f=1} f==1&&/^file/{print $1;exit}' ~/.config/nitrogen/bg-saved.cfg | sed '/^file=/{s/^file=//;}')
WALLPAPER2=$(awk '/^\[xin_1\]/{f=1} f==1&&/^file/{print $1;exit}' ~/.config/nitrogen/bg-saved.cfg | sed '/^file=/{s/^file=//;}')
betterlockscreen -u $WALLPAPER1 -u $WALLPAPER2 --display 0

dunstify -u low -h string:x-dunst-stack-tag:lockscreen "Lockscreen updated!" -t 2000
