#!/usr/bin/env bash
# Waybar: now playing (any MPRIS player, e.g. YouTube Music in Chrome).
# Hidden when stopped or when a tab exposes a player without metadata.
export LC_ALL=C.UTF-8

MAX=22
# Kill playerctl too, otherwise it outlives waybar restarts
trap 'pkill -P $$' EXIT
trap 'exit 0' TERM INT HUP PIPE

json_escape() {
  local s="${1//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '%s' "${s//$'\n'/\\n}"
}

# Drop YouTube noise like "(Official Video)", "[Lyrics]", "(4K)"
clean_title() {
  sed -E 's/[[:space:]]*[([][^])]*(official|video|audio|lyric|clip|visuali[sz]er|hd|4k|mv)[^])]*[])]//Ig; s/[[:space:]]+$//' <<<"$1"
}

echo '{"text":""}'  # start hidden until a player reports metadata

playerctl -F metadata --format $'{{status}}\t{{artist}}\t{{title}}\t{{playerName}}' 2>/dev/null |
  while IFS=$'\t' read -r status artist title player; do
    if [[ -z "$title" || "$status" == "Stopped" ]]; then
      echo '{"text":""}'
      continue
    fi
    short="$(clean_title "$title")"
    ((${#short} > MAX)) && short="${short:0:MAX-1}…"
    icon="󰝚" class="playing"
    [[ "$status" == "Paused" ]] && icon="󰏤" && class="paused"
    tooltip="$player: ${artist:+$artist - }$title"$'\n'"Click: play/pause · Scroll: next/prev · Right click: media panel"
    printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' \
      "$(json_escape "$icon $short")" "$class" "$(json_escape "$tooltip")"
  done &
wait
