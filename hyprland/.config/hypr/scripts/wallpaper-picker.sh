#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
HYPRPAPER_CONF="$HOME/.config/hypr/hyprpaper.conf"
CACHE_FILE="$HOME/.cache/last_wallpaper"
MONITORS=("HDMI-A-1" "eDP-1")

# Guard: don't stack if tofi is already open
pgrep -x tofi > /dev/null && exit 0

# Bail if no images exist
IMAGE_COUNT=$(find -L "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | wc -l)
if [[ "$IMAGE_COUNT" -eq 0 ]]; then
    notify-send "Wallpaper" "No images found in $WALLPAPER_DIR"
    exit 1
fi

# Show filenames (not full paths) in tofi
SELECTED=$(find -L "$WALLPAPER_DIR" -maxdepth 1 -type f \
    \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) \
    -printf '%f\n' | sort \
    | tofi -c "$HOME/.config/tofi/configV" --prompt-text " Wallpaper: ")

# Empty selection = user cancelled
[[ -z "$SELECTED" ]] && exit 0

FULL_PATH="$WALLPAPER_DIR/$SELECTED"

# Verify the constructed path actually exists
if [[ ! -f "$FULL_PATH" ]]; then
    notify-send "Wallpaper" "File not found: $FULL_PATH"
    exit 1
fi

# Apply wallpaper and regenerate colors
"$HOME/.config/hypr/scripts/apply-wallpaper.sh" "$FULL_PATH"
