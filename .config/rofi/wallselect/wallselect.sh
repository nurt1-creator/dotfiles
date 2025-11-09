#!/bin/bash

source "$HOME"/.config/rofi/wallselect/shared/theme.bash
theme="$type/$style"
folder="$HOME/.config/hypr/image/"

wallpaper_list=$(find "$folder" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)
entries=""
for wp in $wallpaper_list; do
    filename=$(basename "$wp")
    entries+="$filename\0icon\x1f$wp\n"
done

selected=$(printf "$entries" | rofi -dmenu \
    -show-icons \
    -theme "$theme" \
    -p "󰉏 Select wallpaper")

if [ -n "$selected" ]; then
    full_path="$folder/$selected"
    
    swww img "$full_path" \
        --transition-type wave \
        --transition-step 120 \
        --transition-fps 144 \
        --transition-duration 1.5

    notify-send "Wallpaper changed" "Installed: $selected"
fi
