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

trap 'error "Script beklenmedik şekilde durdu. Son komut hata verdi."' ERR

[ "${EUID}" -eq 0 ] && error "Bu scripti root olarak çalıştırma!"

DOTFILES_DIR="${HOME}/.dotfiles"
ZPROFILE="${HOME}/.zprofile"

# ------------------------------------------------------------
# Paket listeleri
# ------------------------------------------------------------
PACMAN_PKGS=(
  amd-ucode
  base
  base-devel
  bat
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
  dunst
  efibootmgr
  egl-wayland
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
  satty
  sddm
  sof-firmware
  speedtest-cli
  spice-vdagent
  starship
  stow
  sudo
  swww
  thunar
  thunar-archive-plugin
  tofi
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
  zoxide
  zram-generator
  zsh

  # GTK / GSettings / icon / mime fix paketleri
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
  catppuccin-gtk-theme-mocha
  cloudflare-warp-bin
  google-chrome
  grimblast-git
  obsidian
  pycharm
  vesktop-bin
  visual-studio-code-bin
  wlogout
)

# ------------------------------------------------------------
step "1. Sistem güncelleme"
# ------------------------------------------------------------
info "Sistem güncelleniyor..."
sudo pacman -Syu --noconfirm
success "Sistem güncellendi"

# ------------------------------------------------------------
step "2. yay kurulumu"
# ------------------------------------------------------------
if ! command -v yay >/dev/null 2>&1; then
  info "yay kuruluyor..."
  sudo pacman -S --noconfirm --needed git base-devel
  rm -rf /tmp/yay
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (
    cd /tmp/yay
    makepkg -si --noconfirm
  )
  success "yay kuruldu"
else
  success "yay zaten kurulu"
fi

# ------------------------------------------------------------
step "3. Pacman paketleri"
# ------------------------------------------------------------
info "Pacman paketleri kuruluyor..."
sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
success "Pacman paketleri kuruldu"

# ------------------------------------------------------------
step "4. AUR paketleri"
# ------------------------------------------------------------
info "AUR paketleri kuruluyor..."
yay -S --noconfirm --needed "${AUR_PKGS[@]}"
success "AUR paketleri kuruldu"

# ------------------------------------------------------------
step "5. Servisler"
# ------------------------------------------------------------
info "NetworkManager etkinleştiriliyor..."
sudo systemctl enable --now NetworkManager

info "Bluetooth etkinleştiriliyor..."
sudo systemctl enable --now bluetooth

info "Docker etkinleştiriliyor..."
sudo systemctl enable --now docker

info "SDDM etkinleştiriliyor..."
sudo systemctl enable sddm

info "PipeWire kullanıcı servisleri etkinleştiriliyor..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber || true

success "Servisler ayarlandı"

# ------------------------------------------------------------
step "6. Kullanıcı grup üyelikleri"
# ------------------------------------------------------------
info "Kullanıcı gerekli gruplara ekleniyor..."
sudo usermod -aG libvirt,docker "${USER}" || true
success "Grup üyelikleri ayarlandı (yeniden giriş gerekli)"

# ------------------------------------------------------------
step "7. GTK / schema / mime / pixbuf düzeltmeleri"
# ------------------------------------------------------------
info "Schema ve cache'ler güncelleniyor..."
sudo glib-compile-schemas /usr/share/glib-2.0/schemas || true
sudo update-mime-database /usr/share/mime || true
sudo gdk-pixbuf-query-loaders --update-cache || true
success "GTK cache'leri güncellendi"

# ------------------------------------------------------------
step "8. XDG_DATA_DIRS düzeltmesi"
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
success "~/.zprofile güncellendi"

# ------------------------------------------------------------
step "9. XDG kullanıcı dizinleri"
# ------------------------------------------------------------
xdg-user-dirs-update || true
success "XDG dizinleri oluşturuldu"

# ------------------------------------------------------------
step "10. Dotfiles"
# ------------------------------------------------------------
if [ ! -d "${DOTFILES_DIR}" ]; then
  info "Dotfiles klonlanıyor..."
  if ssh -T git@github.com >/dev/null 2>&1; then
    git clone git@github.com:Eraybeylik/dotfiles.git "${DOTFILES_DIR}"
  else
    warn "SSH yok, HTTPS ile klonlanıyor..."
    git clone https://github.com/Eraybeylik/dotfiles.git "${DOTFILES_DIR}"
  fi
else
  info "Dotfiles zaten mevcut, güncelleniyor..."
  (
    cd "${DOTFILES_DIR}"
    git pull --ff-only || true
  )
fi

if [ -d "${DOTFILES_DIR}" ]; then
  cd "${DOTFILES_DIR}"
  info "Stow ile dotfiles bağlanıyor..."
  for pkg in hyprland waybar kitty dunst tofi wlogout btop starship gtk-3.0 gtk-4.0 nvim zsh wallpapers assets; do
    [ -d "${pkg}" ] && stow "${pkg}" || true
  done
  success "Dotfiles bağlandı"
else
  warn "Dotfiles dizini bulunamadı, stow atlandı"
fi

# ------------------------------------------------------------
step "11. Wallpaper dizini"
# ------------------------------------------------------------
mkdir -p "${HOME}/Pictures/Wallpapers"
success "Wallpaper dizini hazır"

# ------------------------------------------------------------
step "12. Varsayılan shell"
# ------------------------------------------------------------
if [ "${SHELL}" != "$(command -v zsh)" ]; then
  info "Varsayılan shell zsh yapılıyor..."
  chsh -s "$(command -v zsh)"
  success "Zsh ayarlandı (yeniden giriş gerekli)"
else
  success "Zsh zaten varsayılan"
fi

# ------------------------------------------------------------
step "13. Son kontroller"
# ------------------------------------------------------------
for cmd in waybar pavucontrol blueman-manager nmtui brightnessctl playerctl docker virt-manager hyprland; do
  if command -v "${cmd}" >/dev/null 2>&1; then
    success "${cmd} bulundu"
  else
    warn "${cmd} bulunamadı"
  fi
done

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Kurulum tamamlandı!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}Sonraki adımlar:${NC}"
echo "  1. reboot at"
echo "  2. giriş ekranında Hyprland seç"
echo "  3. yeniden giriş yaptıktan sonra grup üyelikleri aktif olur"
echo ""
echo -e "${CYAN}Not:${NC}"
echo "  - Waybar / GTK / GSettings bozulursa ~/.zprofile içindeki XDG_DATA_DIRS satırını kontrol et"
echo "  - Docker için yeniden giriş gerekebilir"
echo "  - Libvirt için virt-manager kullanmadan önce yeniden giriş yap"
