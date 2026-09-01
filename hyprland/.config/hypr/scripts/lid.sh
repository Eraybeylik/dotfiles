#!/usr/bin/env bash
# Clamshell mode for the laptop lid.
#
# With an external monitor attached, logind treats the machine as docked and
# ignores the lid switch, so closing the lid did nothing; here we disable the
# internal panel instead and re-enable it on open.
# Without an external monitor logind handles the lid itself
# (HandleLidSwitch=hibernate in /etc/systemd/logind.conf) - we stay out of it.

INTERNAL="eDP-1"
INTERNAL_MODE="1920x1080@144,0x0,1"

external_active() {
    hyprctl monitors -j | jq -e --arg m "$INTERNAL" \
        'map(select(.name != $m)) | length > 0' >/dev/null
}

case "$1" in
    close)
        external_active && hyprctl keyword monitor "$INTERNAL, disable"
        ;;
    open)
        hyprctl keyword monitor "$INTERNAL, $INTERNAL_MODE"
        ;;
    *)
        echo "usage: lid.sh close|open" >&2
        exit 1
        ;;
esac
