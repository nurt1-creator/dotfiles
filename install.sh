#!/usr/bin/env bash

set -euo pipefail

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Colorized logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

log_debug() {
    echo -e "${CYAN}[DEBUG]${NC} $1"
}

log_info "Starting setup..."

if grep -q "Arch Linux" /etc/os-release; then
    log_step "Updating system packages..."
    sudo pacman -Syu --noconfirm

    log_step "Installing required packages..."
    sudo pacman -S --needed --noconfirm \
        git \
        base-devel \
        hyprland \
        waybar \
        swaync \
        firefox \
        kitty \
        neovim \
        pamixer \
        pipewire \
        jq \
        grim \
        slurp \
        wl-clipboard \
        cliphist \
        pavucontrol \
        fastfetch \
        networkmanager \
        rofi \
        polkit-kde-agent \
        ttf-firacode-nerd \
        ttf-jetbrains-mono \
        sddm \
        swww \
        p7zip \
        wget \
        dolphin \
        zsh \
        mpd \
        gum \

    if ! command -v yay &> /dev/null; then
        log_step "Installing yay AUR helper..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
        log_success "yay installed successfully"
    else
        log_info "yay is already installed."
    fi

    log_step "Installing AUR packages..."
    yay -S --noconfirm swaylock-effects
    log_success "AUR packages installed"
fi

log_step "Installing Font Awesome..."
wget https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip
7z x fontawesome-free-6.5.2-desktop.zip
cd fontawesome-free-6.5.2-desktop
sudo mkdir -p /usr/share/fonts/OTF/fontawesome6/
sudo cp otfs/*.otf /usr/share/fonts/OTF/fontawesome6/
fc-cache -fv
cd -
rm -rf fontawesome-free-6.5.2-desktop.zip fontawesome-free-6.5.2-desktop
log_success "Font Awesome installed"

log_step "Setting Zsh as default shell..."
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
log_success "Zsh configured"

if [[ -d ~/dotfiles ]]; then
    log_step "Copying dotfiles..."
    mkdir -p ~/.config
    cp -r ~/dotfiles/.config/* ~/.config/
    sudo cp -r ~/dotfiles/.icons/share/* /usr/icons/share
    cp ~/dotfiles/.zshrc ~/dotfiles/.p10k.zsh ~/
    log_success "Dotfiles copied"
else
    log_error "~/dotfiles directory not found."
    exit 1
fi

if [ -d "$HOME/.config/hypr/Scripts" ]; then
    log_step "Making Hyprland scripts executable..."
    find "$HOME/.config/hypr/Scripts" -type f -exec chmod +x {} \;
    log_success "Hyprland scripts made executable"
fi

if [ -d "$HOME/.config/rofi" ]; then
    log_step "Making Rofi scripts executable..."
    find "$HOME/.config/rofi/launcher" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/powermenu" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/screenshot" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/mplayer" -type f -exec chmod +x {} \;
    log_success "Rofi scripts made executable"
fi

if [ -d "$HOME/.config/rofi" ]; then
    log_step "Making Rofi scripts executable..."
    find "$HOME/.config/sddm/sddm-astronaut-theme" -type f -exec chmod +x {} \;
    log_success "SDDM theme scripts made executable"
fi

log_step "Setting up SDDM astronaut theme..."
./~dotfiles/sddm/sddm-astronaut-theme/setup.sh -t pixel_sakura
log_success "SDDM theme configured"

log_step "Enabling SDDM display manager..."
sudo systemctl enable sddm
log_success "SDDM enabled"

echo
read -rp $'\e[1;32mAll done. Reboot now? [y/N]: \e[0m' response
if [[ "$response" =~ ^[Yy]$ ]]; then
    log_step "Rebooting..."
    reboot
else
    log_success "Setup finished without reboot."
    exit 0
fi
