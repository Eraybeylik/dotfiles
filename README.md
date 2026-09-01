<div align="center">

# 🐧 xera's dotfiles

**Arch Linux · Hyprland · Matugen Dynamic Theming · Nvidia**

Personal Wayland desktop setup — wallpaper-driven Material You theming across every app, a Lua-configured Hyprland, and a one-shot install script that rebuilds the whole machine from a fresh Arch install.

[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-1793D1?logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/WM-Hyprland-58E1FF?logo=wayland&logoColor=white)](https://hyprland.org)
[![Matugen](https://img.shields.io/badge/Theming-Matugen-8ab4f8)](https://github.com/InioX/matugen)
[![Shell](https://img.shields.io/badge/Shell-Zsh%20%2B%20Zinit-89e051)](https://zsh.org)
[![Last Commit](https://img.shields.io/github/last-commit/Eraybeylik/dotfiles)](https://github.com/Eraybeylik/dotfiles/commits/main)

</div>

---

## ✨ Highlights

- **Wallpaper → theme, everywhere.** Matugen extracts a Material You palette from the active wallpaper and regenerates GTK, Kitty, Rofi, Waybar, hyprlock, starship, and an Obsidian snippet in one pass.
- **Hyprland in Lua.** `hyprland.lua` / `keybinds.lua` / `programs.lua` use Hyprland's native Lua config (0.55+) instead of raw `hyprland.conf` — real variables, loops, and shared program definitions.
- **One-key system menu.** `SUPER + SPACE` opens a Rofi menu for capture, style, toggles and power — with a live, searchable keybind cheatsheet (`SUPER + K`) generated straight from `keybinds.lua`.
- **Laptop-aware.** Clamshell mode when docked, a caffeine toggle to hold off idle/lock, and a staged `hypridle` (lock → screen off → suspend).
- **Reproducible.** `install.sh` takes a bare Arch install to a fully themed Hyprland desktop: packages, AUR, services, dotfiles, shell — no manual steps beyond partitioning/base install.
- **Fast shell.** Zsh + Zinit in turbo mode, `zsh-vi-mode`, fzf-tab completion, autosuggestions, syntax highlighting.

## 📦 Components

| Config | Description |
|---|---|
| `hyprland` | Compositor, keybinds, hypridle, hyprlock (Lua config) |
| `waybar` | Status bar |
| `kitty` | Terminal emulator |
| `rofi` | Application launcher |
| `swaync` | Notification center |
| `wlogout` | Logout menu |
| `matugen` | Dynamic color generation from wallpaper |
| `fastfetch` | System info display |
| `btop` | System monitor |
| `starship` | Shell prompt |
| `zsh` | Shell, Zinit plugins, aliases |
| `tmux` | Terminal multiplexer |
| `nvim` | Neovim (LazyVim) |
| `waypaper` | Wallpaper manager GUI |
| `awww` | Wallpaper switcher with transitions |

## 🚀 Installation

> Assumes a base Arch Linux install with a non-root sudo user already booted (e.g. via `archinstall`). The script handles everything from there — it refuses to run as root.

```bash
# 1. Clone the repo
git clone https://github.com/Eraybeylik/dotfiles.git

# 2. Run the install script
cd ~/.dotfiles
chmod +x install.sh
./install.sh

# 3. Reboot
sudo reboot
```

`install.sh` will:

1. Update the system and install `yay`
2. Install all pacman + AUR packages (Hyprland, GTK stack, Nvidia drivers, dev tools, apps)
3. Bootstrap `uv` and `opencode` via their official installers
4. Enable services (NetworkManager, Bluetooth, Docker, SDDM, PipeWire)
5. Apply GTK/GSettings/XDG fixes
6. Clone (or update) this repo and symlink every package with `stow`
7. Set Zsh as the default shell
8. Run a final check for every tool it just installed

## ⌨️ Keybindings

<details>
<summary><strong>Applications</strong></summary>

| Keybind | Action |
|---|---|
| `SUPER + RETURN` | Terminal (Kitty) |
| `SUPER + W` | Browser (Google Chrome) |
| `SUPER + O` | Notes (Obsidian) |
| `SUPER + C` | Editor (opencode) |
| `SUPER + SHIFT + C` | Editor (Sublime Text) |
| `SUPER + E` | File Manager (Thunar) |
| `SUPER + R` | Launcher (Rofi) |
| `SUPER + SHIFT + R` | Rofi launcher style changer |
| `SUPER + I` | Web search (Rofi) |
| `SUPER + A` | Webapp launcher (sites as `chrome --app` windows) |
| `SUPER + SPACE` | System menu (capture / style / toggle / power) |
| `SUPER + K` | Keybind cheatsheet (Rofi, searchable) |

</details>

<details>
<summary><strong>Window management</strong></summary>

| Keybind | Action |
|---|---|
| `SUPER + Q` | Kill active window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + F` | Toggle floating |
| `SUPER + SHIFT + F` | Fullscreen |

</details>

<details>
<summary><strong>Focus &amp; move windows</strong></summary>

| Keybind | Action |
|---|---|
| `SUPER + ←/→/↑/↓` | Move focus |
| `SUPER + SHIFT + ←/→/↑/↓` | Move window |

</details>

<details>
<summary><strong>Workspaces</strong></summary>

| Keybind | Action |
|---|---|
| `SUPER + 1-9` | Switch to workspace 1–9 |
| `SUPER + 0` | Switch to workspace 10 |
| `SUPER + SHIFT + 1-9` | Move window to workspace 1–9 |
| `SUPER + SHIFT + 0` | Move window to workspace 10 |
| `SUPER + S` | Toggle special workspace |
| `SUPER + SHIFT + S` | Move window to special workspace |
| `SUPER + Mouse Up/Down` | Next / previous workspace |
| `SUPER + LMB` | Move window (drag) |
| `SUPER + RMB` | Resize window (drag) |

</details>

<details>
<summary><strong>Utilities</strong></summary>

| Keybind | Action |
|---|---|
| `SUPER + V` | Clipboard history (cliphist + Rofi) |
| `SUPER + SHIFT + W` | Wallpaper picker |
| `SUPER + P` | Color picker (hyprpicker) |
| `SUPER + L` | Lock screen (hyprlock) |
| `SUPER + ESCAPE` | Logout menu (wlogout) |
| `CTRL + ESCAPE` | Toggle Waybar |
| `SUPER + SHIFT + B` | Waybar theme selector |
| `SUPER + CTRL + I` | Caffeine toggle (hold off idle/lock) |
| `SUPER + CTRL + Z` / `SUPER + CTRL + ALT + Z` | Screen zoom in / reset |
| `Lid close` / `Lid open` | Clamshell mode when an external monitor is attached |

</details>

<details>
<summary><strong>Screenshots &amp; OCR</strong></summary>

| Keybind | Action |
|---|---|
| `SUPER + Print` | Select region → edit with Swappy |
| `SUPER + SHIFT + Print` | Full screen → edit with Swappy |
| `Print` | Active window → edit with Swappy |
| `SUPER + CTRL + Print` | Select region → OCR text (Tesseract) to clipboard |

</details>

<details>
<summary><strong>Volume, media &amp; brightness</strong></summary>

| Keybind | Action |
|---|---|
| `XF86AudioRaiseVolume` / `XF86AudioLowerVolume` | Volume ±5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Mute microphone |
| `XF86AudioPlay` / `XF86AudioPause` | Play / Pause |
| `XF86AudioNext` / `XF86AudioPrev` | Next / previous track |
| `XF86MonBrightnessUp` / `XF86MonBrightnessDown` | Brightness ±5% |

</details>

## 🧩 Scripts

Everything in `hyprland/.config/hypr/scripts/` and `rofi/.config/rofi/scripts/`, all invoked from keybinds or the system menu:

| Script | Purpose |
|---|---|
| `sysmenu.sh` | Rofi system menu — Capture / Style / Toggle / System / Keybinds / Webapps |
| `keybinds-cheatsheet.sh` | Parses `keybinds.lua` live and shows a searchable Rofi list |
| `caffeine.sh` | Toggles `hypridle` on/off, reports status to Waybar |
| `lid.sh` | Clamshell mode — disables the internal panel on lid close only if an external monitor is active |
| `ocr.sh` | Region select → Tesseract (tur+eng) → clipboard |
| `wallSelect.sh` | Wallpaper picker with a resized-thumbnail cache, feeds Matugen |
| `matugenMagick.sh` | Regenerates Rofi preview images and the GTK theme after a wallpaper change |
| `waybarSelect.sh` | Waybar theme switcher |
| `webapp.sh` (rofi) | Opens a site from `rofi/webapps.list` as its own `chrome --app` window |

## 🎨 Theming pipeline

Changing the wallpaper (via `waypaper`, the Rofi wallpaper picker, or `wallSelect.sh`) triggers Matugen, which reads `matugen/.config/matugen/config.toml` and regenerates every downstream template in one run:

```
wallpaper ──▶ matugen ──▶ GTK 3/4 · Kitty · Rofi · Waybar · hyprlock · starship · Obsidian
```

Colors land as Hyprland Lua variables too (`hyprland/.config/hypr/matugen/colors.lua`), so window borders, shadows, and glow follow the palette without a reload.

## 🙏 Credits

Some ideas here were ported from other projects and adapted to this stack (own Lua/bash implementations, not copied code):

- [omarchy](https://github.com/basecamp/omarchy) (MIT) — inspiration for the system menu, keybind cheatsheet, clamshell mode, caffeine toggle, and full environment import on session start.
- [gh0stzk](https://github.com/gh0stzk) — original `wallSelect.sh` wallpaper picker.
- [The HyDE Project](https://github.com/HyDE-Project/HyDE) — base Rofi launcher styles under `rofi/launchers/`.

## 📄 License

Personal configuration files, shared as-is for reference. No warranty — read before you `stow`.
