#!/usr/bin/env bash
# Push matugen colors + current wallpaper to the SilentSDDM login screen.
# The data dir is created by system/sddm/setup-sddm-theme.sh; skip quietly until then.

data=/var/lib/silent-matugen
conf="$HOME/.cache/matugen/sddm-silent.conf"
wallpaper=$(cat "$HOME/.cache/last_wallpaper" 2>/dev/null)

[ -w "$data" ] || exit 0

[ -f "$conf" ] && install -m 644 "$conf" "$data/matugen.conf"

# [0] = first frame, so gifs/animated images work too. Write to a temp file and
# rename so the greeter never sees a half-written image.
if [ -f "$wallpaper" ]; then
  magick "${wallpaper}[0]" -strip -resize 1920x1080^ -gravity center -extent 1920x1080 -quality 90 "$data/.wallpaper.jpg" &&
    chmod 644 "$data/.wallpaper.jpg" &&
    mv -f "$data/.wallpaper.jpg" "$data/wallpaper.jpg"
fi
