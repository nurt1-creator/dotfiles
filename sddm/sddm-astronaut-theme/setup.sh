#!/bin/bash

## SDDM Astronaut Theme Installer
## Based on original by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
## Copyright (C) 2022-2025 Keyitdev

# Script works in Arch, Fedora, Ubuntu. Didn't tried in Void and openSUSE

set -euo pipefail

readonly THEME_REPO="https://github.com/Keyitdev/sddm-astronaut-theme.git"
readonly THEME_NAME="sddm-astronaut-theme"
readonly THEMES_DIR="/usr/share/sddm/themes"
readonly PATH_TO_GIT_CLONE="$HOME/$THEME_NAME"
readonly DATE=$(date +%s)

# Default theme - change this to your preferred theme
readonly DEFAULT_THEME="astronaut"

# Logging functions
info() {
    echo -e "\e[32m✅ $*\e[0m"
}

warn() {
    echo -e "\e[33m⚠  $*\e[0m"
}

error() {
    echo -e "\e[31m❌ $*\e[0m" >&2
}

# Install dependencies
install_deps() {
    info "Installing dependencies..."
    local mgr=$(for m in pacman xbps dnf zypper apt; do command -v $m &>/dev/null && { echo ${m%%-*}; break; }; done)
    info "Package manager: $mgr"

    case $mgr in
        pacman) sudo pacman --needed -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg ;;
        xbps) sudo xbps-install -y sddm qt6-svg qt6-virtualkeyboard qt6-multimedia ;;
        dnf) sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia ;;
        zypper) sudo zypper install -y sddm libQt6Svg6 qt6-virtualkeyboard qt6-multimedia ;;
        apt) sudo apt update && sudo apt install -y sddm qt6-svg-dev qml6-module-qtquick-virtualkeyboard qt6-multimedia-dev ;;
        *) error "Unsupported package manager"; return 1 ;;
    esac
    info "Dependencies installed"
}

# Clone repository
clone_repo() {
    info "Cloning theme repository..."
    [[ -d "$PATH_TO_GIT_CLONE" ]] && mv "$PATH_TO_GIT_CLONE" "${PATH_TO_GIT_CLONE}_$DATE"
    git clone -b master --depth 1 "$THEME_REPO" "$PATH_TO_GIT_CLONE"
    info "Repository cloned to $PATH_TO_GIT_CLONE"
}

# Install theme
install_theme() {
    local src="$HOME/$THEME_NAME"
    local dst="$THEMES_DIR/$THEME_NAME"

    [[ ! -d "$src" ]] && { error "Clone repository first"; return 1;}

    info "Installing theme files..."
    # Backup and copy
    [[ -d "$dst" ]] && sudo mv "$dst" "${dst}_$DATE"
    sudo mkdir -p "$dst"
    sudo cp -r "$src"/* "$dst"/

    # Install fonts
    if [[ -d "$dst/Fonts" ]]; then
        info "Installing fonts..."
        sudo cp -r "$dst/Fonts"/* /usr/share/fonts/
    fi

    # Set default theme
    local metadata="$dst/metadata.desktop"
    if [[ -f "$metadata" ]]; then
        sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${DEFAULT_THEME}.conf|" "$metadata"
        info "Theme variant set to: $DEFAULT_THEME"
    fi

    # Configure SDDM
    info "Configuring SDDM..."
    echo "[Theme]
Current=$THEME_NAME" | sudo tee /etc/sddm.conf >/dev/null

    sudo mkdir -p /etc/sddm.conf.d
    echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf >/dev/null

    info "Theme installed successfully"
}

# Enable SDDM
enable_sddm() {
    command -v systemctl &>/dev/null || { error "systemctl not found"; return 1; }

    info "Enabling SDDM service..."
    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    info "SDDM enabled"
}

# Main installation function
main_install() {
    [[ $EUID -eq 0 ]] && { error "Don't run as root"; exit 1; }
    command -v git &>/dev/null || { error "git required"; exit 1; }

    info "Starting automatic installation of SDDM Astronaut Theme"
    info "Default theme: $DEFAULT_THEME"
    
    # Ask for confirmation before proceeding
    echo
    read -p "Continue with installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Installation cancelled"
        exit 0
    fi

    install_deps
    clone_repo
    install_theme
    enable_sddm
    
    info "[SDDM] Installation completed successfully!"
}

# Show usage information
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Automated SDDM Astronaut Theme installer"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -t, --theme    Set theme variant (default: astronaut)"
    echo "                 Available themes: astronaut, black_hole, cyberpunk, hyprland_kath,"
    echo "                 jake_the_dog, japanese_aesthetic, pixel_sakura, pixel_sakura_static,"
    echo "                 post-apocalyptic_hacker, purple_leaves"
    echo
    echo "Examples:"
    echo "  $0                    # Install with default astronaut theme"
    echo "  $0 -t cyberpunk       # Install with cyberpunk theme"
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -t|--theme)
                if [[ -n "$2" ]]; then
                    case "$2" in
                        astronaut|black_hole|cyberpunk|hyprland_kath|jake_the_dog|japanese_aesthetic|pixel_sakura|pixel_sakura_static|post-apocalyptic_hacker|purple_leaves)
                            DEFAULT_THEME="$2"
                            ;;
                        *)
                            error "Invalid theme: $2"
                            show_usage
                            exit 1
                            ;;
                    esac
                    shift 2
                else
                    error "Theme name required"
                    show_usage
                    exit 1
                fi
                ;;
            *)
                error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

# Main execution
if [[ $# -eq 0 ]]; then
    main_install
else
    parse_args "$@"
    main_install
fi
