<div align="center">

# xera's dotfiles

**Arch Linux · Hyprland · Matugen Dynamic Theming · Nvidia**

</div>

## Components

| Config | Description |
|--------|-------------|
| `hyprland` | Compositor, keybinds, hypridle, hyprlock |
| `waybar` | Status bar |
| `kitty` | Terminal emulator |
| `rofi` | Application launcher |
| `swaync` | Notification center |
| `wlogout` | Logout menu |
| `matugen` | Dynamic color generation from wallpaper |
| `fastfetch` | System info display |
| `btop` | System monitor |
| `starship` | Shell prompt |
| `zsh` | Shell + aliases |
| `nvim` | Neovim (LazyVim) |
| `waypaper` | Wallpaper manager GUI |
| `awww` | Wallpaper switcher with transitions |

## Installation

```bash
# 1. Clone the repo
git clone git@github.com:Eraybeylik/dotfiles.git ~/.dotfiles

# 2. Run the install script
cd ~/.dotfiles
chmod +x install.sh
./install.sh

# 3. Reboot
sudo reboot
```

## Keybindings

### Applications

| Keybind | Action |
|---------|--------|
| `SUPER + RETURN` | Terminal (Kitty) |
| `SUPER + W` | Browser (Google Chrome) |
| `SUPER + O` | Notes (Obsidian) |
| `SUPER + C` | Editor (VS Code) |
| `SUPER + SHIFT + C` | Editor (Sublime) |
| `SUPER + E` | File Manager (Thunar) |
| `SUPER + R` | Launcher (Rofi) |
| `SUPER + SHIFT + R` | Rofi launcher style changer |
| `SUPER + I` | Web search (Rofi) |

### Window Management

| Keybind | Action |
|---------|--------|
| `SUPER + Q` | Kill active window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + F` | Toggle floating |
| `SUPER + SHIFT + F` | Fullscreen |

### Focus

| Keybind | Action |
|---------|--------|
| `SUPER + ←` | Move focus left |
| `SUPER + →` | Move focus right |
| `SUPER + ↑` | Move focus up |
| `SUPER + ↓` | Move focus down |

### Move Windows

| Keybind | Action |
|---------|--------|
| `SUPER + SHIFT + ←` | Move window left |
| `SUPER + SHIFT + →` | Move window right |
| `SUPER + SHIFT + ↑` | Move window up |
| `SUPER + SHIFT + ↓` | Move window down |

### Workspaces

| Keybind | Action |
|---------|--------|
| `SUPER + 1-9` | Switch to workspace 1–9 |
| `SUPER + 0` | Switch to workspace 10 |
| `SUPER + SHIFT + 1-9` | Move window to workspace 1–9 |
| `SUPER + SHIFT + 0` | Move window to workspace 10 |
| `SUPER + S` | Toggle special workspace |
| `SUPER + SHIFT + S` | Move window to special workspace |
| `SUPER + Mouse Up` | Next workspace |
| `SUPER + Mouse Down` | Previous workspace |
| `SUPER + LMB` | Move window (drag) |
| `SUPER + RMB` | Resize window (drag) |

### Utilities

| Keybind | Action |
|---------|--------|
| `SUPER + V` | Clipboard history (cliphist + Rofi) |
| `SUPER + SHIFT + W` | Wallpaper picker |
| `SUPER + P` | Color picker (hyprpicker) |
| `SUPER + L` | Lock screen (hyprlock) |
| `SUPER + ESCAPE` | Logout menu (wlogout) |
| `CTRL + ESCAPE` | Toggle Waybar |
| `SUPER + SHIFT + B` | Waybar theme selector |

### Screenshots

| Keybind | Action |
|---------|--------|
| `SUPER + Print` | Select region → edit with Satty |
| `SUPER + SHIFT + Print` | Full screen → edit with Satty |
| `Print` | Active window → edit with Satty |

### Volume & Media

| Keybind | Action |
|---------|--------|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Mute microphone |
| `XF86AudioPlay` | Play / Pause |
| `XF86AudioPause` | Play / Pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |

### Brightness

| Keybind | Action |
|---------|--------|
| `XF86MonBrightnessUp` | Brightness +5% |
| `XF86MonBrightnessDown` | Brightness -5% |
