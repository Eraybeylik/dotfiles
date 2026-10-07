#!/usr/bin/env bash
# Auto power profile: balanced normally, power-saver on battery below LOW%.
# Also warns to plug in once the battery drops to CRIT% on battery.
# Only switches when the wanted profile changes (plug/unplug, crossing a
# threshold), so a manual pick from waybar sticks until the next transition.

LOW=30    # on battery at or below this -> power-saver
HIGH=35   # back to balanced above this (gap avoids flapping around 30%)
CRIT=10   # on battery at or below this -> "plug in" warning
INTERVAL=${INTERVAL:-30}

BAT=${BAT:-/sys/class/power_supply/BAT1}
AC=${AC:-/sys/class/power_supply/ACAD/online}

# Single instance (Hyprland restarts / manual runs)
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/power-auto.lock"
flock -n 9 || exit 0

wanted=""
last=""
warned=0

while true; do
  cap="$(cat "$BAT/capacity" 2>/dev/null)"
  online="$(cat "$AC" 2>/dev/null)"

  if [[ "$online" == "1" ]]; then
    wanted="balanced"
  elif [[ -n "$cap" ]] && ((cap <= LOW)); then
    wanted="power-saver"
  elif [[ -n "$cap" ]] && ((cap > HIGH)); then
    wanted="balanced"
  fi
  # between LOW and HIGH on battery: keep the previous decision
  [[ -z "$wanted" ]] && wanted="balanced"

  if [[ "$wanted" != "$last" ]]; then
    powerprofilesctl set "$wanted"
    if [[ -n "$last" ]]; then
      if [[ "$wanted" == "power-saver" ]]; then
        notify-send -i battery-caution "Pil %$cap" "Güç tasarrufu moduna geçildi"
      else
        notify-send -i battery "Güç profili" "Balanced moda dönüldü"
      fi
    fi
    last="$wanted"
  fi

  # Critical urgency stays on screen until dismissed; re-armed once plugged
  # in or back above CRIT, so it fires once per low-battery episode
  if [[ "$online" != "1" && -n "$cap" ]] && ((cap <= CRIT)); then
    if ((warned == 0)); then
      notify-send -u critical -i battery-empty "Pil %$cap" "Pil kritik seviyede, şarja tak!"
      warned=1
    fi
  else
    warned=0
  fi

  sleep "$INTERVAL" 9>&-  # do not hand the lock to sleep
done
