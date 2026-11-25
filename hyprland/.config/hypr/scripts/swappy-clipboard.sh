#!/usr/bin/env bash
# Open the image currently in the clipboard in swappy for editing.

type=$(wl-paste --list-types 2>/dev/null | grep -m1 '^image/')

if [ -z "$type" ]; then
    notify-send "Swappy" "Panoda resim yok"
    exit 1
fi

wl-paste --type "$type" | swappy -f -
