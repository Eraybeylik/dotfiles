#!/usr/bin/env bash
# Wire SilentSDDM to matugen. Run as: sudo system/sddm/setup-sddm-theme.sh
#
# The greeter runs as the `sddm` user and cannot read $HOME, so matugen output
# (colors + wallpaper) is synced to a user-owned dir in /var/lib and the theme
# reaches it through two symlinks. Only data (an INI file and a JPEG) lives
# there — no QML — so the user cannot inject code into the greeter.
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "Run with sudo" >&2; exit 1; }
owner="${SUDO_USER:?Run via sudo from your user account}"

theme=/usr/share/sddm/themes/silent
data=/var/lib/silent-matugen
here="$(cd "$(dirname "$0")" && pwd)"

[ -d "$theme" ] || { echo "SilentSDDM not installed (yay -S sddm-silent-theme)" >&2; exit 1; }

install -d -m 755 -o "$owner" -g "$owner" "$data"
install -D -m 644 -o root -g root "$here/10-silent-theme.conf" /etc/sddm.conf.d/10-silent-theme.conf

ln -sfn "$data/matugen.conf" "$theme/configs/matugen.conf"
ln -sfn "$data/wallpaper.jpg" "$theme/backgrounds/matugen.jpg"
# metadata.desktop is in the package's backup=() list, so this edit survives upgrades.
sed -i 's|^ConfigFile=.*|ConfigFile=configs/matugen.conf|' "$theme/metadata.desktop"

echo "Done. Now run ~/.config/hypr/scripts/sddm-sync.sh as $owner to seed colors + wallpaper."
