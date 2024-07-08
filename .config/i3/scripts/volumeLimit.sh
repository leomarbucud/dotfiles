#!/bin/bash

# kill itself first
kill -9 $(pgrep -f ${BASH_SOURCE[0]} | grep -v $$)

max_volume=130 # in percent

pactl subscribe \
| grep --line-buffered 'sink ' \
| stdbuf -o0 cut -d# -f2 \
| while read index; do
    volume=$(pactl get-sink-volume $index | head -n1 | cut -d/ -f2 | tr -d ' %');
    if (( volume > max_volume )); then
        pactl set-sink-volume $index $max_volume%;
    fi;
    # dunstify -u low -h string:x-dunst-stack-tag:obvolume "Volume: $volume%" -t 1000
done