#!/bin/bash

dunstify -u low -h string:x-dunst-stack-tag:wallpaper "Setting up wallpaper..." -t 5000

# Wallpaper folder
FOLDER="$HOME/Pictures/wallpapers"

# Random wallpaper
random() {
    ARR=($FOLDER/*)
    i=$(($RANDOM % ${#ARR[@]} + 1))
    random_wall=${ARR[$i]}
    echo $random_wall
}

WALLPAPER1=$(random)
WALLPAPER2=$(random)
sed -i '2s@file=.*@file='$WALLPAPER1'@' ~/.config/nitrogen/bg-saved.cfg
sed -i '7s@file=.*@file='$WALLPAPER2'@' ~/.config/nitrogen/bg-saved.cfg
sleep 2
nitrogen --restore 2> /dev/null

dunstify -u low -h string:x-dunst-stack-tag:wallpaper "Wallpaper set!" -t 2000

# ~/.config/i3/scripts/updateLock.sh
