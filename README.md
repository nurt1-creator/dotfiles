# 🚀 Hyprland Dotfiles / EN

My configuration files for the **Hyprland** environment on **Arch Linux**.
This repository contains settings for creating a productive and aesthetically pleasing workspace.

![Top Language](https://img.shields.io/github/languages/top/nurt1-creator/dotfiles?style=for-the-badge)
![License](https://img.shields.io/github/license/nurt1-creator/dotfiles?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/nurt1-creator/dotfiles?style=for-the-badge)

---

## ✨ Features

- **Environment:** modern Wayland compositor Hyprland
- **Panel:** Waybar with custom modules and themes
- **Window manager / launcher:** Rofi for launching apps, window control, and clipboard handling
- **Aesthetics:** custom SDDM theme *Astronaut*, color schemes, icons, and fonts
- **Convenience:** automatic installation via `install.sh`

---

## ⚙️ Installation (Arch Linux)

> ⚠️ The installation will overwrite existing config files. Make a backup beforehand.

### 1. Clone the repository

```bash
git clone https://github.com/nurt1-creator/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installation script
```bash
chmod +x install.sh
./install.sh
```

The script will:
- Update the system and install all required packages (Hyprland, Waybar, Rofi, Kitty, etc.)
- Install the AUR helper yay and AUR packages
- Copy all configuration files into the appropriate directories (~/.config, ~/.zshrc, etc.)
- Configure Zsh + Oh My Zsh + Powerlevel10k
- Install and activate the SDDM theme Astronaut.
- A reboot is recommended after installation.

## 🎨 Screenshots

(to be added later)
## 🛠️ Dependencies
#### Main packages installed by the script:
- **Compositor**: hyprland
- **Panel**: waybar
- **Terminal**: kitty
- **Application launcher**: rofi
- **Fonts**: ttf-jetbrains-mono, ttf-firacode-nerd
- **Utilities**: git, zsh, fastfetch, wl-clipboard, grim, slurp, jq, mpd, gum
- **AUR**: yay, swaylock-effects

Full list — inside `install.sh`
## 🧩 Custom Components
- **SDDM Theme**: sddm-astronaut-theme (pixel_sakura variant)
- **Rofi Scripts**: MPRIS controller, clipboard menu (cliphist), power menu

## 📄 License

The project is distributed under the GNU GPL v3.0. <p>
The full license text is available in the LICENSE file.

---

# 🚀 Hyprland Dotfiles / RU

Мои конфигурационные файлы для окружения **Hyprland** на **Arch Linux**. Репозиторий содержит настройки для создания продуктивного и эстетичного рабочего пространства.

![Top Language](https://img.shields.io/github/languages/top/nurt1-creator/dotfiles?style=for-the-badge)
![License](https://img.shields.io/github/license/nurt1-creator/dotfiles?style=for-the-badge)
![Last Commit](https://img.shields.io/github/last-commit/nurt1-creator/dotfiles?style=for-the-badge)

---

## ✨ Особенности

- **Окружение:** современный Wayland-композитор Hyprland
- **Панель:** Waybar с кастомными модулями и темами
- **Менеджер окон:** Rofi для запуска приложений, управления окнами и буфером обмена
- **Эстетика:** кастомная тема SDDM *Astronaut*, цветовые схемы, иконки и шрифты
- **Удобство:** автоматическая установка через `install.sh`

---

## ⚙️ Установка (Arch Linux)

> ⚠️ Установка перезапишет существующие конфиги. Сделай резервную копию.

### 1. Клонируй репозиторий

```bash
git clone https://github.com/nurt1-creator/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Запусти скрипт установки

```bash
chmod +x install.sh
./install.sh
```

#### Скрипт выполнит:
- Обновление системы и установку необходимых пакетов (Hyprland, Waybar, Rofi, Kitty и др.);
- Установку AUR-хелпера yay и AUR-пакетов;
- Копирование всех конфигов в нужные директории (~/.config, ~/.zshrc и др.);
- Настройку Zsh + Oh My Zsh + Powerlevel10k;
- Установку и активацию темы SDDM Astronaut.
- После установки рекомендуется перезагрузиться.
## 🎨 Скриншоты

(будут добавлены позже)
## 🛠️ Зависимости

#### Основные пакеты, устанавливаемые скриптом:
- **Композитор**: hyprland
- **Панель**: waybar
- **Терминал**: kitty
- **Менеджер приложений**: rofi
- **Шрифты**: ttf-jetbrains-mono, ttf-firacode-nerd
- **Утилиты**: git, zsh, fastfetch, wl-clipboard, grim, slurp, jq, mpd, gum
- **AUR**: yay, swaylock-effects

Полный список — в `install.sh`

## 🧩 Кастомные компоненты
- **Тема SDDM**: sddm-astronaut-theme (вариант pixel_sakura)
- **Скрипты Rofi**: MPRIS-контроллер, clipboard-меню (cliphist), power-menu

## 📄 Лицензия

Проект распространяется под GNU GPL v3.0. <p>
Полный текст лицензии находится в файле LICENSE.
