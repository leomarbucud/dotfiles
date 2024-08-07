#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/polybar"

# Terminate already running bar instances
killall -q polybar

XRANDR=$(which xrandr)

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
if type "xrandr"; then
    for m in $($XRANDR --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m \
        polybar -q main -c "$DIR"/config.ini &
    done
else
    polybar --reload example &
fi
