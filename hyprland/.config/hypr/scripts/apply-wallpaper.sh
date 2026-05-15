#!/usr/bin/env bash
set -uo pipefail

# Get wallpaper path from argument or waypaper config
if [[ $# -ge 1 && -f "$1" ]]; then
    WALLPAPER="$1"
else
    WALLPAPER=$(python3 -c "
import configparser, os
c = configparser.RawConfigParser()
c.read(os.path.expanduser('~/.config/waypaper/config.ini'))
print(os.path.expanduser(c.get('Settings', 'wallpaper', fallback='')))
")
fi

[[ -f "$WALLPAPER" ]] || { echo "File not found: $WALLPAPER" >&2; exit 1; }

# Generate colors with matugen
matugen image "$WALLPAPER" --source-color-index 0

# Save last wallpaper
printf '%s\n' "$WALLPAPER" > "$HOME/.cache/last_wallpaper"
~/.config/hypr/scripts/matugenMagick.sh
