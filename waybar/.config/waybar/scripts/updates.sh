#!/usr/bin/env bash
# Waybar: pending repo + AUR updates. Empty text hides the module when up to date.

repo="$(checkupdates 2>/dev/null)"
aur="$(yay -Qua 2>/dev/null)"

count() { [[ -n "$1" ]] && wc -l <<<"$1" || echo 0; }
n_repo=$(count "$repo")
n_aur=$(count "$aur")
total=$((n_repo + n_aur))

if ((total == 0)); then
  echo '{"text":"","class":"updated"}'
  exit
fi

list="$(printf '%s\n%s' "$repo" "$aur" | sed '/^$/d' | awk '{print $1, $4}' | head -n 20)"
((total > 20)) && list+="\n..."
tooltip="Repo: $n_repo  AUR: $n_aur\n\n$list"

jq -cn --arg text "$total" --arg tooltip "$(printf '%b' "$tooltip")" \
  '{text: $text, tooltip: $tooltip, class: "pending"}'
