#!/bin/bash

folder="$HOME/.config/hypr/image/"
theme="$HOME/.config/rofi/apps.rasi"

# Генерируем список с иконками
wallpaper_list=$(find "$folder" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.svg" \) | sort)

entries=""
for wp in $wallpaper_list; do
    filename=$(basename "$wp")
    entries+="$filename\x00icon\x1f$wp\n"
done

# Показываем список
selected=$(echo -e "$entries" | rofi -dmenu -markup-rows -show-icons -theme "$theme" -p "Select wallpaper:")

# Устанавливаем
if [ -n "$selected" ]; then
    full_path="$folder/$selected"
    swww img "$full_path"
fi
