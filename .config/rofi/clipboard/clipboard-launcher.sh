#!/usr/bin/env bash

## Author : nurti (nurt1-creator)

dir="$HOME/.config/rofi/clipboard"
theme='style'

## Run
cliphist list | rofi -dmenu -i -p "󰅍 Clipboard" -theme "${dir}/${theme}.rasi" | cliphist decode | wl-copy
