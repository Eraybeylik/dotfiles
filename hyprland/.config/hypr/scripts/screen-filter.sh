#!/usr/bin/env bash
# Screen filter: toggle a full-screen shader.
#   warm      - night light (yellow tint, less blue)      SUPER+CTRL+N
#   grayscale - e-book mode (black & white)               SUPER+CTRL+G
# Toggling the active filter again turns it off; picking the other one switches.
# Also shown in waybar next to brightness (custom/nightlight, custom/ebook).

SHADER_DIR="$HOME/.config/hypr/shaders"

notify() {
    notify-send -e -h string:x-canonical-private-synchronous:screen-filter "Screen filter" "$1"
}

current_shader() {
    hyprctl getoption decoration:screen_shader | sed -n 's/^str: //p'
}

# Partial damage + screen shader leaves half-filtered frames / glitches around
# the cursor (NVIDIA), so redraw full frames while a filter is on.
set_shader() {
    local damage=2
    [ -n "$1" ] && damage=0
    hyprctl eval "hl.config({ debug = { damage_tracking = $damage }, decoration = { screen_shader = '$1' } })" >/dev/null
    pkill -SIGRTMIN+11 waybar
}

case "$1" in
    warm|grayscale)
        target="$SHADER_DIR/$1.frag"
        if [ "$(current_shader)" = "$target" ]; then
            set_shader ""
            notify "Off"
        else
            set_shader "$target"
            notify "On - $1"
        fi
        ;;
    off)
        set_shader ""
        notify "Off"
        ;;
    status)
        case "$2" in
            warm)      icon="󰖔"; name="Night light" ;;
            grayscale) icon="󰂵"; name="E-book mode" ;;
            *) echo "usage: screen-filter.sh status warm|grayscale" >&2; exit 1 ;;
        esac
        if [ "$(current_shader)" = "$SHADER_DIR/$2.frag" ]; then
            printf '{"text":"%s","tooltip":"%s on - click to turn off","class":"active"}\n' "$icon" "$name"
        else
            printf '{"text":"%s","tooltip":"%s off - click to turn on","class":"inactive"}\n' "$icon" "$name"
        fi
        ;;
    *)
        echo "usage: screen-filter.sh warm|grayscale|off|status warm|grayscale" >&2
        exit 1
        ;;
esac
