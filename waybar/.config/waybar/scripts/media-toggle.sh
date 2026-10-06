#!/usr/bin/env bash
# Waybar: play/pause icon that follows the active MPRIS player.
trap 'pkill -P $$' EXIT
trap 'exit 0' TERM INT HUP PIPE

playerctl -F status 2>/dev/null | sed -u 's/^Playing$/󰏤/;s/^Paused$/󰐊/;s/^Stopped$/󰐊/' &
wait
