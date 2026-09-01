#!/usr/bin/env bash
# Searchable keybind cheatsheet (SUPER+K), generated live from keybinds.lua.

KEYBINDS="$HOME/.config/hypr/keybinds.lua"

python3 - "$KEYBINDS" <<'EOF' | rofi -dmenu -i -p "Keybinds" -config "$HOME/.config/rofi/applets/rofiSelect.rasi" >/dev/null
import re, sys

rows = []
comment = ""
for ln in open(sys.argv[1]):
    s = ln.strip()
    if s.startswith("--") and not s.startswith("---"):
        comment = s.lstrip("-").strip()
        continue
    if not s:
        comment = ""
        continue
    # Loop-generated workspace binds are appended manually below
    if re.search(r"\.\.\s*key", s):
        continue
    m = re.match(r'hl\.bind\(\s*(mainMod\s*\.\.\s*)?"([^"]+)"\s*,\s*(.*)', s)
    if not m:
        continue
    key = ("SUPER" + m.group(2)) if m.group(1) else m.group(2)
    rest = m.group(3)
    mm = re.search(r'exec_cmd\("(.+?)"\)', rest)
    if mm:
        action = mm.group(1)
    else:
        mm = re.search(r"exec_cmd\(([^)]+)\)", rest)
        if mm:
            action = mm.group(1)
        else:
            mm = re.search(r"hl\.dsp\.([A-Za-z_.]+)\(", rest)
            action = mm.group(1) if mm else (comment or rest[:50])
    if comment and comment not in action:
        action = f"{action}   [{comment}]"
    rows.append((key, action))

rows.append(("SUPER + 1..0", "focus workspace 1-10 (on current monitor)"))
rows.append(("SUPER + SHIFT + 1..0", "move window to workspace 1-10"))

width = max(len(k) for k, _ in rows)
for k, a in rows:
    print(f"{k.ljust(width)}   {a}")
EOF
