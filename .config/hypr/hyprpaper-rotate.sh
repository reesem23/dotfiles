#!/bin/bash

WALLS=(~/Pictures/wallpapers/*.jpg)
PREV=""

while true; do
  for WALL in "${WALLS[@]}"; do
    hyprctl hyprpaper preload "$WALL"
    hyprctl hyprpaper wallpaper ",$WALL"
    if [[ -n "$PREV" && "$PREV" != "$WALL" ]]; then
      hyprctl hyprpaper unload "$PREV"
    fi
    PREV="$WALL"
    sleep 30
  done
done
