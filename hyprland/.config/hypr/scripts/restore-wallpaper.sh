#!/usr/bin/env bash
sleep 2
LAST_WALLPAPER="$HOME/.cache/last_wallpaper"
if [ -f "$LAST_WALLPAPER" ]; then
  wallpaper=$(cat "$LAST_WALLPAPER")
  if [ -f "$wallpaper" ]; then
    awww img "$wallpaper" --transition-type fade --transition-duration 1
  fi
fi
