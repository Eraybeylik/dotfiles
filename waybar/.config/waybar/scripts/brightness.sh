#!/usr/bin/env bash
# Waybar: laptop backlight + external monitors (DDC/CI via ddcutil), kept in sync.
# Usage: brightness.sh [get|up|down]
# Laptop panel is the source of truth; externals follow its percentage after a
# short debounce, because ddcutil is slow (~0.5s per write) and scrolls burst.

STEP=5
STATE="${XDG_RUNTIME_DIR:-/tmp}/waybar-brightness"
mkdir -p "$STATE"

laptop_pct() {
  brightnessctl -m | awk -F, '{gsub("%", "", $4); print $4}'
}

sync_externals() {
  command -v ddcutil >/dev/null || return
  local pid_file="$STATE/sync.pid"
  [[ -f "$pid_file" ]] && kill "$(cat "$pid_file")" 2>/dev/null
  (
    sleep 0.4
    pct="$(laptop_pct)"
    # Detect buses once; DDC detection is the slowest part
    [[ -s "$STATE/buses" ]] || ddcutil detect --brief 2>/dev/null |
      awk '/^Display/ {ok=1} /^Invalid/ {ok=0} ok && /I2C bus:/ {sub(".*i2c-", ""); print}' >"$STATE/buses"
    while read -r bus; do
      ddcutil --bus "$bus" --noverify setvcp 10 "$pct" 2>/dev/null
    done <"$STATE/buses"
    echo "$pct" >"$STATE/external"
    rm -f "$pid_file"
  ) &
  echo $! >"$pid_file"
}

case "$1" in
  up)   brightnessctl -q set "${STEP}%+"; sync_externals; pkill -RTMIN+10 waybar ;;
  down) brightnessctl -q set "${STEP}%-"; sync_externals; pkill -RTMIN+10 waybar ;;
  *)
    pct="$(laptop_pct)"
    icons=(󰃞 󰃟 󰃠)
    icon="${icons[$((pct * 3 / 101))]}"
    ext="$(cat "$STATE/external" 2>/dev/null)"
    if ! command -v ddcutil >/dev/null; then
      tip="Laptop: ${pct}%\nExternal: ddcutil not installed"
    else
      tip="Laptop: ${pct}%\nExternal: ${ext:-not synced yet}%"
    fi
    printf '{"text":"%s %s%%","tooltip":"%s"}\n' "$icon" "$pct" "$tip"
    ;;
esac
