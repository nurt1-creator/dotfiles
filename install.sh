#!/usr/bin/env bash

set -euo pipefail

if grep -q "Arch Linux" /etc/os-release; then
    sudo pacman -Syu --noconfirm

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
        pulseaudio \
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
	dolphin

    if ! command -v yay &> /dev/null; then
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
    fi

    yay -S --noconfirm swaylock-effects
fi

if [[ -d ~/ ]]; then
    wget https://github.com/FortAwesome/Font-Awesome/releases/download/6.5.2/fontawesome-free-6.5.2-desktop.zip
    7z x fontawesome-free-6.5.2-desktop.zip
    cd fontawesome-free-6.5.2-desktop
    sudo mkdir -p /usr/share/fonts/OTF/fontawesome6/
    sudo cp otfs/*.otf /usr/share/fonts/OTF/fontawesome6/
    fc-cache -fv
fi
    
if [[ -d ~/dotfiles ]]; then
    mkdir -p ~/.config
    cp -r ~/dotfiles/.config/* ~/.config/
    cp -r  ~/dotfiles/.oh-my-zsh/ ~/
else
    echo "Directory not found." >&2
    exit 1
fi

if [ -d "$HOME/.config/hypr/Scripts" ]; then
    find "$HOME/.config/hypr/Scripts" -type f -exec chmod +x {} \;
fi

sudo systemctl enable sddm
echo

read -rp $'\e[1;31mAll done. Reboot now? [y/N] \e[0m' response
if [[ "$response" =~ ^[Yy]$ ]]; then
    reboot
else
    echo
    echo "Reboot rejected. Exiting..."
    exit 0
fi
