#!/usr/bin/env bash
# Waybar: play/pause icon that follows the active MPRIS player.
trap 'pkill -P $$' EXIT TERM INT

playerctl -F status 2>/dev/null | sed -u 's/^Playing$/󰏤/;s/^Paused$/󰐊/;s/^Stopped$/󰐊/' &
wait
