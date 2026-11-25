#!/usr/bin/env bash
# Rofi window switcher (pseudo-overview): same glass style as the launcher.
style_dir="$HOME/.config/rofi/launchers/styles"
style_theme='style-10'

pkill rofi || true
rofi -show window -modi window -show-icons \
    -display-window " " \
    -window-format "{c} · {t}" \
    -theme "${style_dir}/${style_theme}.rasi"
