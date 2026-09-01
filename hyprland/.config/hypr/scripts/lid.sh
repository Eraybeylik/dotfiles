#!/usr/bin/env bash
# Clamshell mode for the laptop lid.
#
# With an external monitor attached, logind treats the machine as docked and
# ignores the lid switch, so closing the lid did nothing; here we disable the
# internal panel instead and re-enable it on open.
# Without an external monitor logind handles the lid itself
# (HandleLidSwitch=hibernate in /etc/systemd/logind.conf) - we stay out of it.

INTERNAL="eDP-1"

external_active() {
    hyprctl monitors -j | jq -e --arg m "$INTERNAL" \
        'map(select(.name != $m and .disabled != true)) | length > 0' >/dev/null
}

case "$1" in
    close)
        external_active && hyprctl eval "hl.monitor({ output = \"$INTERNAL\", disabled = true })"
        ;;
    open)
        # Same rule as hyprland.lua's monitor block; explicit disabled=false,
        # otherwise the eval leaves an already-disabled panel off
        hyprctl eval "hl.monitor({ output = \"$INTERNAL\", mode = \"1920x1080@144\", position = \"0x0\", scale = 1, disabled = false })"
        ;;
    *)
        echo "usage: lid.sh close|open" >&2
        exit 1
        ;;
esac
