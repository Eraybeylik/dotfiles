#!/usr/bin/env bash
# Waybar: now playing (any MPRIS player, e.g. YouTube Music in Chrome) with a
# tiny cava spectrum inside the same pill. Hidden when stopped or when a tab
# exposes a player without metadata.
export LC_ALL=C.UTF-8

MAX=22
tmp="$(mktemp -d -t waybar-media.XXXXXX)"
# Kill playerctl/cava too, otherwise they outlive waybar restarts
trap 'pkill -P $$; rm -rf "$tmp"' EXIT
trap 'exit 0' TERM INT HUP PIPE

cat >"$tmp/cava.conf" <<CONF
[general]
framerate = 20
bars = 6
sleep_timer = 3

[input]
method = pipewire
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bar_delimiter = 59
CONF

mkfifo "$tmp/events"
exec 3<>"$tmp/events"

playerctl -F metadata --format $'M\t{{status}}\t{{artist}}\t{{title}}\t{{playerName}}' 2>/dev/null >&3 &
if command -v cava >/dev/null; then
  cava -p "$tmp/cava.conf" 2>/dev/null |
    sed -u -e 's/;//g;y/01234567/▁▂▃▄▅▆▇█/' -e 's/^/C\t/' >&3 &
fi

json_escape() {
  local s="${1//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '%s' "${s//$'\n'/\\n}"
}

# Drop YouTube noise like "(Official Video)", "[Lyrics]", "(4K)"
clean_title() {
  sed -E 's/[[:space:]]*[([][^])]*(official|video|audio|lyric|clip|visuali[sz]er|hd|4k|mv)[^])]*[])]//Ig; s/[[:space:]]+$//' <<<"$1"
}

status="" title="" short="" tooltip="" bars="" last=""

render() {
  local out
  if [[ -z "$title" || "$status" == "Stopped" ]]; then
    out='{"text":""}'
  else
    local icon="󰝚" class="playing"
    [[ "$status" == "Paused" ]] && icon="󰏤" && class="paused"
    local text="$icon $short"
    [[ -n "$bars" ]] && text+=" $bars"
    out="{\"text\":\"$(json_escape "$text")\",\"class\":\"$class\",\"tooltip\":\"$(json_escape "$tooltip")\"}"
  fi
  [[ "$out" != "$last" ]] && printf '%s\n' "$out" && last="$out"
}

render
while IFS=$'\t' read -r -u 3 kind a b c d; do
  case "$kind" in
    M)
      status="$a" title="$c"
      short="$(clean_title "$c")"
      ((${#short} > MAX)) && short="${short:0:MAX-1}…"
      tooltip="$d: ${b:+$b - }$c"$'\n'"Click: play/pause · Scroll: next/prev · Right click: media panel"
      ;;
    C)
      # All-lowest bars = silence: hide the spectrum
      [[ "$a" =~ ^▁*$ ]] && bars="" || bars="$a"
      ;;
  esac
  render
done
