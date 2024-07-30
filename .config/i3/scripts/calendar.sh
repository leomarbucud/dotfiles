#!/bin/bash

yad --calendar \
    --undecorated \
    --fixed \
    --show-weeks \
    --title Calendar \
    --height="200" \
    --width="350" \
    --no-buttons > /dev/null &

