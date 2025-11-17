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

# Function to install video drivers
install_video_drivers() {
    log_step "Select video card drivers to install"
    
    echo -e "${CYAN}Available video drivers:${NC}"
    echo -e "1) ${GREEN}NVIDIA${NC} (nvidia nvidia-utils)"
    echo -e "2) ${GREEN}AMD${NC} (mesa vulkan-radeon)"
    echo -e "3) ${GREEN}Intel${NC} (mesa vulkan-intel)"
    echo -e "4) ${GREEN}All open-source${NC} (mesa vulkan-radeon vulkan-intel)"
    echo -e "5) ${YELLOW}Skip driver installation${NC}"
    
    read -rp $'\e[1;32mSelect option [1-5]: \e[0m' driver_choice
    
    case $driver_choice in
        1)
            log_step "Installing NVIDIA drivers..."
            sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
            log_success "NVIDIA drivers installed"
            ;;
        2)
            log_step "Installing AMD drivers..."
            sudo pacman -S --noconfirm mesa vulkan-radeon
            log_success "AMD drivers installed"
            ;;
        3)
            log_step "Installing Intel drivers..."
            sudo pacman -S --noconfirm mesa vulkan-intel
            log_success "Intel drivers installed"
            ;;
        4)
            log_step "Installing all open-source drivers..."
            sudo pacman -S --noconfirm mesa vulkan-radeon vulkan-intel
            log_success "All open-source drivers installed"
            ;;
        5)
            log_warn "Skipping video driver installation"
            ;;
        *)
            log_error "Invalid selection, skipping driver installation"
            ;;
    esac
}

# Function to install Oh My Zsh
install_omz() {
    log_step "Installing Oh My Zsh..."
    # Используем полностью unattended установку
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    log_step "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    
    log_success "Oh My Zsh and Powerlevel10k installed"
}

log_info "Starting setup..."

log_step "Setting Zsh as default shell (temporary)..."
if ! command -v zsh &> /dev/null; then
    sudo pacman -S --noconfirm zsh
fi
sudo chsh -s $(which zsh) $USER
log_success "Zsh set as default shell"

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
        pipewire-pulse \
        pipewire-alsa \
        pipewire-jack \
        wireplumber \
        jq \
        code \
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
        ttf-cascadia-code \
        noto-fonts-emoji \
        sddm \
        swww \
        p7zip \
        wget \
        dolphin \
        lsd \
        gum \
        xdg-desktop-portal-hyprland \

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
    yay -S --noconfirm swaylock-effects \
        papirus-icon-theme
    log_success "AUR packages installed"
    
    # Video driver selection
    install_video_drivers
fi

log_step "Installing Font Awesome..."
wget -q https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip
7z x -y fontawesome-free-6.5.2-desktop.zip > /dev/null 2>&1
cd fontawesome-free-6.5.2-desktop
sudo mkdir -p /usr/share/fonts/TTF/fontawesome6/
sudo cp otfs/*.otf /usr/share/fonts/TTF/fontawesome6/
fc-cache -fv > /dev/null 2>&1
cd -
rm -rf fontawesome-free-6.5.2-desktop.zip fontawesome-free-6.5.2-desktop
log_success "Font Awesome installed"

if [[ -d ~/dotfiles ]]; then
    log_step "Copying dotfiles..."
    mkdir -p ~/.config
    sudo mkdir -p /usr/share/icons  
    cp -r ~/dotfiles/.config/* ~/.config/
    sudo cp -r ~/dotfiles/.icons/* /usr/share/icons
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
    find "$HOME/.config/rofi/wallselect" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/clipboard" -type f -exec chmod +x {} \;
    log_success "Rofi scripts made executable"
fi

if [[ -d "$HOME/dotfiles/sddm/sddm-astronaut-theme" ]]; then
    log_step "Making SDDM theme scripts executable..."
    find "$HOME/dotfiles/sddm/sddm-astronaut-theme" -type f -name "*.sh" -exec chmod +x {} \;
    log_success "SDDM theme scripts made executable"
fi

if [[ -f "$HOME/dotfiles/sddm/sddm-astronaut-theme/setup.sh" ]]; then
    log_step "Setting up SDDM astronaut theme..."
    cd "$HOME/dotfiles/sddm/sddm-astronaut-theme"
    ./setup.sh -t pixel_sakura
    cd -
    log_success "SDDM theme configured"
else
    log_error "SDDM theme setup script not found at $HOME/dotfiles/sddm/sddm-astronaut-theme/setup.sh"
fi

log_step "Enabling PipeWire services..."
systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
log_success "PipeWire services enabled"

log_step "Enabling SDDM display manager..."
sudo systemctl enable sddm
log_success "SDDM enabled"

echo
read -rp $'\e[1;32mAll done. Reboot now? [y/N]: \e[0m' response

log_step "Installing Oh My Zsh..."
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

log_step "Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

log_success "Oh My Zsh and Powerlevel10k installed"

if [[ "$response" =~ ^[Yy]$ ]]; then
    log_step "Rebooting..."
    sudo reboot
else
    log_success "Setup finished without reboot."
    log_warn "Please restart your terminal or log out and log back in to use Zsh with Oh My Zsh"
    exit 0
fi
