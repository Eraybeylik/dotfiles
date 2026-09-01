#!/usr/bin/env bash
# Webapp launcher: pick a site from ~/.config/rofi/webapps.list and open it
# as its own chrome --app window. Bound to SUPER+A.

LIST="$HOME/.config/rofi/webapps.list"

[ -f "$LIST" ] || { notify-send -e "Webapps" "$LIST not found"; exit 1; }

choice=$(grep -v '^\s*#' "$LIST" | grep -v '^\s*$' | cut -d'|' -f1 |
    rofi -dmenu -i -p "Webapp" -theme "$HOME/.config/rofi/applets/menu.rasi")

[ -n "$choice" ] || exit 0

url=$(grep -v '^\s*#' "$LIST" | awk -F'|' -v c="$choice" '$1 == c { print $2; exit }')

[ -n "$url" ] || exit 1

exec google-chrome-stable --app="$url" --enable-features=UseOzonePlatform --ozone-platform=wayland
