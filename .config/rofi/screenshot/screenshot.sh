#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Screenshot

# Import Current Theme
source "$HOME"/.config/rofi/screenshot/shared/theme.bash
theme="$type/$style"

# Theme Elements
prompt='Screenshot'
dir="$HOME/Pictures/Screenshots"
mesg="DIR: $dir"

# Create screenshot directory if it doesn't exist
[[ ! -d "$dir" ]] && mkdir -p "$dir"

list_col='5'
list_row='1'
win_width='670px'

option_1=""
option_2=""
option_3=""
option_4=""
option_5=""

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: $win_width;}" \
		-theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Screenshot
time=`date +%Y-%m-%d-%H-%M-%S`
file="Screenshot_${time}.png"

# notify and view screenshot
notify_view() {
	notify_cmd_shot='notify-send'
	if [[ -e "$dir/$file" ]]; then
		${notify_cmd_shot} "Screenshot Saved."
		imv ${dir}/"$file" &
	else
		${notify_cmd_shot} "Screenshot Canceled."
	fi
}

# Copy screenshot to clipboard
copy_shot () {
	wl-copy < "$dir/$file"
}

# countdown
countdown () {
	for sec in `seq $1 -1 1`; do
		notify-send "Taking shot in : $sec"
		sleep 1
	done
}

# take shots
shotnow () {
	sleep 0.5
    grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" "$dir/$file"
	copy_shot
	notify_view
}

shot5 () {
	countdown '4'
    swaync-client -C
    sleep 1
	grim "$dir/$file"
	copy_shot
	notify_view
}

shot10 () {
	countdown '9'    
    swaync-client -C
    sleep 1
	grim "$dir/$file"
	copy_shot
	notify_view
}

shotwin () {
    sleep 0.5
    geom="$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
    grim -g "$geom" "$dir/$file"
    copy_shot
    notify_view
}

shotarea () {
    sleep 0.1s
	grim -g "$(slurp)" "$dir/$file"
	copy_shot
	notify_view
}

# Execute Command
run_cmd() {
	case "$1" in
		--opt1) shotnow ;;
		--opt2) shotarea ;;
		--opt3) shotwin ;;
		--opt4) shot5 ;;
		--opt5) shot10 ;;
	esac
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1) run_cmd --opt1 ;;
    $option_2) run_cmd --opt2 ;;
    $option_3) run_cmd --opt3 ;;
    $option_4) run_cmd --opt4 ;;
    $option_5) run_cmd --opt5 ;;
esac
