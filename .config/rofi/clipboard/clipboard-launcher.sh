#!/usr/bin/env bash

## Author : nurti (nurt1-creator)

dir="$HOME/.config/rofi/clipboard"
theme='style'

options="󰆴 Clear All\n$(cliphist list)"

result=$(echo -e "$options" | rofi -dmenu -i -p "󰅍 Clipboard" -theme "${dir}/${theme}.rasi")

case "$result" in
    "󰆴 Clear All")
        cliphist wipe
        notify-send -u low -t 1500 "Clipboard" "󰆴 Clipboard cleared"
        ;;
    *)
        if [[ -n "$result" ]]; then
            echo "$result" | cliphist decode | wl-copy
            notify-send -u low -t 1500 "Clipboard" "󰅍 Copied to clipboard"
        fi
        ;;
esac
