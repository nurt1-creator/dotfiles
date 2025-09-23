#!/bin/bash

folder="$HOME/.config/hypr/image/"
theme="$HOME/.config/rofi/apps.rasi"
backup="$theme.bak"

# Получаем текущий обои
current_wallpaper=$(swww query | grep 'Image:' | awk '{print $2}')

# Проверка на пустой результат
if [ -z "$current_wallpaper" ]; then
    current_wallpaper="$HOME/.config/hypr/image/default.jpg"
fi

# Создаём бэкап темы
cp "$theme" "$backup"

# Подставляем текущие обои в background-image
sed -i "s|background-image:.*|background-image: url(\"$current_wallpaper\", height);|" "$theme"

# Генерируем список с превью
entries=""
for wp in "$folder"/*.{jpg,jpeg,png,svg}; do
    [ -f "$wp" ] || continue
    filename=$(basename "$wp")
    entries+="$filename\x00icon\x1f$wp\n"
done

# Запускаем rofi
selected=$(echo -e "$entries" | rofi -dmenu -markup-rows -show-icons -theme "$theme" -p "Select wallpaper:")

# Возвращаем оригинальный rasi
mv "$backup" "$theme"

# Устанавливаем выбранный обои
if [ -n "$selected" ]; then
    full_path="$folder/$selected"
    swww img "$full_path" && wal -i "$full_path"
fi

