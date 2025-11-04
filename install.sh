#!/usr/bin/env bash

set -euo pipefail

echo "[INFO] Starting setup..."

if grep -q "Arch Linux" /etc/os-release; then
    echo "[INFO] Updating system packages..."
    sudo pacman -Syu --noconfirm

    echo "[INFO] Installing required packages..."
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
        echo "[INFO] Installing yay AUR helper..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
    else
        echo "[INFO] yay is already installed."
    fi

    echo "[INFO] Installing AUR packages..."
    yay -S --noconfirm swaylock-effects
fi

echo "[INFO] Installing Font Awesome..."
wget https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip
7z x fontawesome-free-6.5.2-desktop.zip
cd fontawesome-free-6.5.2-desktop
sudo mkdir -p /usr/share/fonts/OTF/fontawesome6/
sudo cp otfs/*.otf /usr/share/fonts/OTF/fontawesome6/
fc-cache -fv
cd -
rm -rf fontawesome-free-6.5.2-desktop.zip fontawesome-free-6.5.2-desktop

echo "[INFO] Setting Zsh as default shell..."
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

if [[ -d ~/dotfiles ]]; then
    echo "[INFO] Copying dotfiles..."
    mkdir -p ~/.config
    cp -r ~/dotfiles/.config/* ~/.config/
    sudo cp -r ~/dotfiles/.icons/share/* /usr/icons/share
    cp ~/dotfiles/.zshrc ~/dotfiles/.p10k.zsh ~/
else
    echo "[ERROR] ~/dotfiles directory not found."
    exit 1
fi

if [ -d "$HOME/.config/hypr/Scripts" ]; then
    echo "[INFO] Making Hyprland scripts executable..."
    find "$HOME/.config/hypr/Scripts" -type f -exec chmod +x {} \;
fi

if [ -d "$HOME/.config/rofi" ]; then
    echo "[INFO] Making Rofi scripts executable..."
    find "$HOME/.config/rofi/launcher" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/powermenu" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/screenshot" -type f -exec chmod +x {} \;
    find "$HOME/.config/rofi/mplayer" -type f -exec chmod +x {} \;
fi

if [ -d "$HOME/.config/rofi" ]; then
    echo "[INFO] Making Rofi scripts executable..."
    find "$HOME/.config/sddm/sddm-astronaut-theme" -type f -exec chmod +x {} \;
fi

./~dotfiles/sddm/sddm-astronaut-theme/setup.sh -t pixel_sakura

echo "[INFO] Enabling SDDM display manager..."
sudo systemctl enable sddm

echo
read -rp $'\e[1;32mAll done. Reboot now? [y/N]: \e[0m' response
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "[INFO] Rebooting..."
    reboot
else
    echo "[INFO] Setup finished without reboot."
    exit 0
fi
