#!/usr/bin/env bash
# Caffeine: temporarily disable idle management (hypridle) so the screen
# stays awake. Toggled from waybar (custom/caffeine) or SUPER+CTRL+I.

notify() {
    notify-send -e -h string:x-canonical-private-synchronous:caffeine "Caffeine" "$1"
}

case "$1" in
    toggle)
        if pidof hypridle >/dev/null; then
            pkill -x hypridle
            notify "On - screen stays awake"
        else
            hypridle >/dev/null 2>&1 & disown
            notify "Off - normal idle behavior"
        fi
        pkill -SIGRTMIN+9 waybar
        ;;
    status)
        if pidof hypridle >/dev/null; then
            printf '{"text":"󰒲","tooltip":"Idle: normal - click to keep screen awake","class":"inactive"}\n'
        else
            printf '{"text":"󰅶","tooltip":"Caffeine on - screen stays awake","class":"active"}\n'
        fi
        ;;
    *)
        echo "usage: caffeine.sh toggle|status" >&2
        exit 1
        ;;
esac
