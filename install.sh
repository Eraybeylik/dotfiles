#!/bin/bash

# ============================================================
#  xera's Dotfiles - Fresh Install Script
#  Arch Linux + Hyprland + Nvidia
# ============================================================

set -e

# Renkler
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

# Root kontrolü
[ "$EUID" -eq 0 ] && error "Bu scripti root olarak çalıştırma!"

DOTFILES_DIR="$HOME/.dotfiles"

# ============================================================
step "1. Sistem güncelleme"
# ============================================================
info "Paketler güncelleniyor..."
sudo pacman -Syu --noconfirm

# ============================================================
step "2. AUR helper (yay) kurulumu"
# ============================================================
if ! command -v yay &>/dev/null; then
    info "yay kuruluyor..."
    sudo pacman -S --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd ~
    success "yay kuruldu"
else
    success "yay zaten mevcut"
fi

# ============================================================
step "3. Temel sistem paketleri"
# ============================================================
PACMAN_PKGS=(
    # Hyprland ekosistemi
    hyprland
    hyprlock
    hypridle
    hyprpicker
    xdg-desktop-portal-hyprland
    xdg-user-dirs

    # Wayland araçları
    waybar
    dunst
    tofi
    wlogout
    swww
    wl-clipboard
    cliphist

    # Terminal & Shell
    kitty
    zsh
    starship

    # Ses & Medya
    pamixer
    pipewire
    pipewire-pulse
    wireplumber
    playerctl

    # Parlaklık
    brightnessctl

    # Screenshot
    grimblast-git
    satty

    # Dosya yöneticisi
    thunar
    thunar-archive-plugin
    gvfs

    # Polkit
    polkit-kde-agent

    # Tema & Görünüm
    kvantum
    qt5ct
    qt6ct
    nwg-look
    gtk3
    gtk4

    # Fontlar
    ttf-fira-code
    ttf-fira-sans
    noto-fonts
    noto-fonts-emoji
    ttf-nerd-fonts-symbols

    # Sistem araçları
    btop
    stow
    git
    curl
    wget
    unzip

    # Nvidia
    nvidia-dkms
    nvidia-utils
    libva-nvidia-driver
)

info "Pacman paketleri kuruluyor..."
sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
success "Pacman paketleri kuruldu"

# ============================================================
step "4. AUR paketleri"
# ============================================================
AUR_PKGS=(
    google-chrome
    obsidian
    visual-studio-code-bin
    catppuccin-gtk-theme-mocha
)

info "AUR paketleri kuruluyor..."
yay -S --noconfirm --needed "${AUR_PKGS[@]}"
success "AUR paketleri kuruldu"

# ============================================================
step "5. Dotfiles kurulumu"
# ============================================================
if [ ! -d "$DOTFILES_DIR" ]; then
    info "Dotfiles klonlanıyor..."
    git clone git@github.com:Eraybeylik/dotfiles.git "$DOTFILES_DIR"
else
    info "Dotfiles zaten mevcut, güncelleniyor..."
    cd "$DOTFILES_DIR" && git pull
fi

cd "$DOTFILES_DIR"

info "Symlink'ler oluşturuluyor..."
stow hyprland waybar kitty dunst tofi wlogout btop starship gtk-3.0 gtk-4.0 nvim zsh wallpapers assets

success "Dotfiles bağlandı"

# ============================================================
step "6. Wallpaper dizini"
# ============================================================
mkdir -p ~/Pictures/Wallpapers

# ============================================================
step "7. Zsh varsayılan shell"
# ============================================================
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Zsh varsayılan shell yapılıyor..."
    chsh -s "$(which zsh)"
    success "Zsh ayarlandı (yeniden giriş gerekli)"
else
    success "Zsh zaten varsayılan"
fi

# ============================================================
step "8. Servisler"
# ============================================================
info "Pipewire servisleri etkinleştiriliyor..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber
success "Servisler başlatıldı"

# ============================================================
step "9. XDG kullanıcı dizinleri"
# ============================================================
xdg-user-dirs-update

# ============================================================
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Kurulum tamamlandı! 🎉${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}Sonraki adımlar:${NC}"
echo "  1. Sistemi yeniden başlat: sudo reboot"
echo "  2. Hyprland'a giriş yap"
echo ""
