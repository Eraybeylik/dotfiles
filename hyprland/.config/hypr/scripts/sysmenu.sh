#!/usr/bin/env bash
# System menu (SUPER+SPACE): one entry point for capture, style, toggles and
# power actions, omarchy-menu style but built on rofi.

THEME="$HOME/.config/rofi/applets/menu.rasi"
SCRIPTS="$HOME/.config/hypr/scripts"

menu() { # $1 prompt, stdin: options
    rofi -dmenu -i -p "$1" -theme "$THEME"
}

BACK="󰌍  Back"

while true; do
    choice=$(printf '%s\n' \
        "󰄀  Capture" \
        "󰏘  Style" \
        "󰔡  Toggle" \
        "  System" \
        "󰌌  Keybinds" \
        "󰖟  Webapps" | menu "Menu")

    case "$choice" in
        *Capture)
            sub=$(printf '%s\n' \
                "󰩭  Screenshot area" \
                "󰹑  Screenshot screen" \
                "󱂬  Screenshot window" \
                "󰦨  OCR text from area" \
                "$BACK" | menu "Capture")
            case "$sub" in
                *area)      exec bash -c 'grimblast save area - | swappy -f -' ;;
                *screen)    exec bash -c 'grimblast save screen - | swappy -f -' ;;
                *window)    exec bash -c 'grimblast save active - | swappy -f -' ;;
                *OCR*)      exec "$SCRIPTS/ocr.sh" ;;
                "$BACK")    continue ;;
                *)          exit 0 ;;
            esac
            ;;
        *Style)
            sub=$(printf '%s\n' \
                "󰸉  Wallpaper" \
                "󰍜  Waybar theme" \
                "󱓞  Launcher style" \
                "$BACK" | menu "Style")
            case "$sub" in
                *Wallpaper)  exec "$SCRIPTS/wallSelect.sh" ;;
                *Waybar*)    exec "$SCRIPTS/waybarSelect.sh" ;;
                *Launcher*)  exec "$HOME/.config/rofi/launchers/launcher-style-changer.sh" ;;
                "$BACK")     continue ;;
                *)           exit 0 ;;
            esac
            ;;
        *Toggle)
            sub=$(printf '%s\n' \
                "󰅶  Caffeine" \
                "󰍜  Waybar" \
                "󰍹  Laptop screen" \
                "$BACK" | menu "Toggle")
            case "$sub" in
                *Caffeine)  exec "$SCRIPTS/caffeine.sh" toggle ;;
                *Waybar)    killall waybar || waybar & exit 0 ;;
                *Laptop*)
                    if hyprctl monitors -j | jq -e '.[] | select(.name == "eDP-1")' >/dev/null; then
                        exec "$SCRIPTS/lid.sh" close
                    else
                        exec "$SCRIPTS/lid.sh" open
                    fi
                    ;;
                "$BACK")    continue ;;
                *)          exit 0 ;;
            esac
            ;;
        *System)
            # No Suspend entry: this hardware doesn't support s2idle/S3 (see
            # Arch Linux Hibernate.md) - suspend leaves the NVIDIA GPU
            # corrupted and the machine needs a hard reset. Hibernate only.
            sub=$(printf '%s\n' \
                "󰌾  Lock" \
                "󰋊  Hibernate" \
                "󰜉  Reboot" \
                "󰐥  Shutdown" \
                "󰗽  Logout" \
                "$BACK" | menu "System")
            case "$sub" in
                *Lock)      exec hyprlock ;;
                *Hibernate) exec systemctl hibernate ;;
                *Reboot)    exec systemctl reboot ;;
                *Shutdown)  exec systemctl poweroff ;;
                *Logout)    hyprctl dispatch 'hl.dsp.exit()' 2>/dev/null || hyprctl dispatch exit; exit 0 ;;
                "$BACK")    continue ;;
                *)          exit 0 ;;
            esac
            ;;
        *Keybinds)
            exec "$SCRIPTS/keybinds-cheatsheet.sh"
            ;;
        *Webapps)
            exec "$HOME/.config/rofi/scripts/webapp.sh"
            ;;
        *)
            exit 0
            ;;
    esac
done
