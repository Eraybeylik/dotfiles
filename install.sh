#!/usr/bin/env bash

# ============================================================
#  xera's full Arch install script
#  Fresh install -> packages + services + dotfiles + GTK fixes
# ============================================================

set -Eeuo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step()    { echo -e "\n${CYAN}==>${NC} $1"; }

trap 'error "Script stopped unexpectedly. Last command failed."' ERR

[ "${EUID}" -eq 0 ] && error "Do not run this script as root!"

DOTFILES_DIR="${HOME}/.dotfiles"
ZPROFILE="${HOME}/.zprofile"

# ------------------------------------------------------------
# Package lists
# ------------------------------------------------------------
PACMAN_PKGS=(
  amd-ucode
  adw-gtk-theme
  awww
  base
  base-devel
  bat
  bc
  blueman
  bluez
  bluez-utils
  bridge-utils
  brightnessctl
  btop
  burpsuite
  cliphist
  dnsmasq
  docker
  docker-buildx
  docker-compose
  dosfstools
  efibootmgr
  egl-wayland
  fastfetch
  fd
  fuse3
  git
  grub
  gst-plugin-pipewire
  gtk3
  gtk4
  gvfs
  hypridle
  hyprland
  hyprlock
  hyprpicker
  imagemagick
  jq
  kitty
  kvantum
  less
  libpulse
  libvirt
  linux
  linux-firmware
  linux-headers
  mtools
  nano
  neovim
  network-manager-applet
  networkmanager
  noto-fonts
  noto-fonts-emoji
  nvidia-open-dkms
  nvidia-utils
  nwg-look
  os-prober
  pamixer
  pavucontrol
  pipewire
  pipewire-alsa
  pipewire-jack
  pipewire-pulse
  playerctl
  polkit-kde-agent
  python-pyquery
  python-requests
  qemu-audio-spice
  qemu-base
  qemu-chardev-spice
  qemu-full
  qemu-hw-display-qxl
  qemu-ui-spice-app
  qemu-ui-spice-core
  qt5-wayland
  qt5ct
  qt6-wayland
  qt6ct
  ripgrep
  rofi-wayland
  satty
  sddm
  sof-firmware
  speedtest-cli
  spice-vdagent
  starship
  stow
  sudo
  swaync
  thunar
  thunar-archive-plugin
  ttf-fira-code
  ttf-fira-sans
  ttf-nerd-fonts-symbols
  unzip
  virt-manager
  waybar
  wget
  wireguard-tools
  wireplumber
  wl-clipboard
  wpa_supplicant
  xdg-desktop-portal-hyprland
  xdg-user-dirs
  xxhash
  zoxide
  zram-generator
  zsh

  # GTK / GSettings / icon / mime fix packages
  adwaita-icon-theme
  gdk-pixbuf2
  glib2
  gsettings-desktop-schemas
  hicolor-icon-theme
  librsvg
  shared-mime-info
  xdg-desktop-portal-gtk
)

AUR_PKGS=(
  cloudflare-warp-bin
  matugen
  google-chrome
  grimblast-git
  obsidian
  pycharm
  vesktop-bin
  visual-studio-code-bin
  waypaper
  wlogout
)

# ------------------------------------------------------------
step "1. System update"
# ------------------------------------------------------------
info "Updating system..."
sudo pacman -Syu --noconfirm
success "System updated"

# ------------------------------------------------------------
step "2. yay installation"
# ------------------------------------------------------------
if ! command -v yay >/dev/null 2>&1; then
  info "Installing yay..."
  sudo pacman -S --noconfirm --needed git base-devel
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (
    cd /tmp/yay
    makepkg -si --noconfirm
  )
  success "yay installed"
else
  success "yay already installed"
fi

# ------------------------------------------------------------
step "3. Pacman packages"
# ------------------------------------------------------------
info "Installing pacman packages..."
sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
success "Pacman packages installed"

# ------------------------------------------------------------
step "4. AUR packages"
# ------------------------------------------------------------
info "Installing AUR packages..."
yay -S --noconfirm --needed "${AUR_PKGS[@]}"
success "AUR packages installed"

# ------------------------------------------------------------
step "5. Services"
# ------------------------------------------------------------
info "Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager

info "Enabling Bluetooth..."
sudo systemctl enable --now bluetooth

info "Enabling Docker..."
sudo systemctl enable --now docker

info "Enabling SDDM..."
sudo systemctl enable sddm

info "Enabling PipeWire user services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber || true

# awww-daemon is launched via Hyprland autostart (exec-once = awww-daemon)
success "Services configured"

# ------------------------------------------------------------
step "6. User group memberships"
# ------------------------------------------------------------
info "Adding user to required groups..."
sudo usermod -aG libvirt,docker "${USER}" || true
success "Group memberships set (re-login required)"

# ------------------------------------------------------------
step "7. GTK / schema / mime / pixbuf fixes"
# ------------------------------------------------------------
info "Updating schemas and caches..."
sudo glib-compile-schemas /usr/share/glib-2.0/schemas || true
sudo update-mime-database /usr/share/mime || true
sudo gdk-pixbuf-query-loaders --update-cache || true
success "GTK caches updated"

# ------------------------------------------------------------
step "8. XDG_DATA_DIRS fix"
# ------------------------------------------------------------
if [ -f "${ZPROFILE}" ]; then
  cp "${ZPROFILE}" "${ZPROFILE}.bak.$(date +%s)"
fi

if grep -q '^export XDG_DATA_DIRS=' "${ZPROFILE}" 2>/dev/null; then
  sed -i 's|^export XDG_DATA_DIRS=.*$|export XDG_DATA_DIRS="/usr/local/share:/usr/share"|' "${ZPROFILE}"
else
  {
    echo ""
    echo "# GTK / GSettings / Waybar fix"
    echo 'export XDG_DATA_DIRS="/usr/local/share:/usr/share"'
  } >> "${ZPROFILE}"
fi
success "~/.zprofile updated"

# ------------------------------------------------------------
step "9. XDG user directories"
# ------------------------------------------------------------
xdg-user-dirs-update || true
success "XDG directories created"

# ------------------------------------------------------------
step "10. Dotfiles"
# ------------------------------------------------------------
if [ ! -d "${DOTFILES_DIR}" ]; then
  info "Cloning dotfiles..."
  if ssh -T git@github.com >/dev/null 2>&1; then
    git clone git@github.com:Eraybeylik/dotfiles.git "${DOTFILES_DIR}"
  else
    warn "No SSH key found, cloning via HTTPS..."
    git clone https://github.com/Eraybeylik/dotfiles.git "${DOTFILES_DIR}"
  fi
else
  info "Dotfiles already present, pulling latest..."
  (
    cd "${DOTFILES_DIR}"
    git pull --ff-only || true
  )
fi

if [ -d "${DOTFILES_DIR}" ]; then
  cd "${DOTFILES_DIR}"
  info "Linking dotfiles with stow..."
  for pkg in btop fastfetch gtk-3.0 gtk-4.0 hyprland kitty matugen nvim rofi starship swaync wallpapers waybar wlogout zsh; do
    [ -d "${pkg}" ] && stow "${pkg}" || warn "Directory '${pkg}' not found, skipping"
  done
  success "Dotfiles linked"
else
  warn "Dotfiles directory not found, skipping stow"
fi

# ------------------------------------------------------------
step "11. Wallpaper directory"
# ------------------------------------------------------------
mkdir -p "${HOME}/Pictures/Wallpapers"
success "Wallpaper directory ready"

# ------------------------------------------------------------
step "12. Default shell"
# ------------------------------------------------------------
if [ "${SHELL}" != "$(command -v zsh)" ]; then
  info "Setting default shell to zsh..."
  chsh -s "$(command -v zsh)"
  success "Zsh set as default shell (re-login required)"
else
  success "Zsh already default"
fi

# ------------------------------------------------------------
step "13. Final checks"
# ------------------------------------------------------------
for cmd in waybar rofi swaync pavucontrol blueman-manager nmtui brightnessctl playerctl docker virt-manager hyprland matugen fastfetch waypaper; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    success "${cmd} found"
  else
    warn "${cmd} not found"
  fi
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Installation complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Reboot the system"
echo "  2. Select Hyprland on the login screen"
echo "  3. Group memberships (docker, libvirt) activate after re-login"
echo "  4. awww-daemon starts automatically via Hyprland autostart"
echo ""
echo -e "${CYAN}Notes:${NC}"
echo "  - If Waybar / GTK / GSettings breaks, check XDG_DATA_DIRS in ~/.zprofile"
echo "  - Docker may require re-login to use without sudo"
echo "  - Re-login before using virt-manager with libvirt"
