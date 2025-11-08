#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Edited By : nurti (nurt1-creator)

# Import Current Theme
source "$HOME"/.config/rofi/mplayer/shared/theme.bash
theme="$type/$style"

list_col='6'
list_row='1'

# Get player status
player_status="$(playerctl status 2>/dev/null)"

# Theme Elements
if [[ -z "$player_status" ]]; then
	prompt='Offline'
	mesg="No active player"
else
	artist="$(playerctl metadata artist 2>/dev/null)"
	title="$(playerctl metadata title 2>/dev/null)"
	player="$(playerctl -l 2>/dev/null | head -n1)"
	
	position="$(playerctl position --format '{{ duration(position) }}' 2>/dev/null)"
	length="$(playerctl metadata --format '{{ duration(mpris:length) }}' 2>/dev/null)"
	
	if [[ -n "$position" ]] && [[ -n "$length" ]]; then
		time_str="$position/$length"
	else
		time_str=""
	fi
	
	if [[ -n "$artist" ]] && [[ -n "$title" ]]; then
        if (( ${#title} > 30 )); then
            short_title="${title:0:30}..."
        else
            short_title="$title"
        fi
		prompt="$short_title 「$artist」"
		if [[ -n "$time_str" ]]; then
			mesg="$time_str"
		else
			mesg="$player"
		fi
	elif [[ -n "$title" ]]; then
		prompt="$title"
		if [[ -n "$time_str" ]]; then
			mesg="$time_str :: $player"
		else
			mesg="$player"
		fi
	else
		prompt="Playing"
		mesg="$player"
	fi
fi

# Options
if [[ "$player_status" == "Playing" ]]; then
	option_1=""
else
	option_1=""
fi
option_2=""
option_3=""
option_4=""
option_5="󰴪"
option_6="󰵱"

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
	current_title="$(playerctl metadata title 2>/dev/null)"
	
	if [[ "$1" == '--opt1' ]]; then
		playerctl play-pause && notify-send -u low -t 1500 "$current_title"
	elif [[ "$1" == '--opt2' ]]; then
		playerctl stop
	elif [[ "$1" == '--opt3' ]]; then
		playerctl previous && sleep 2 && notify-send -u low -t 1500 "$(playerctl metadata title 2>/dev/null)"
	elif [[ "$1" == '--opt4' ]]; then
		playerctl next && sleep 2 && notify-send -u low -t 1500 "$(playerctl metadata title 2>/dev/null)"
    elif [[ "$1" == '--opt5' ]]; then
		playerctl position 10- && notify-send -u low -t 1000 "$(playerctl metadata title 2>/dev/null)" "-10 seconds"
	elif [[ "$1" == '--opt6' ]]; then
		playerctl position 10+ && notify-send -u low -t 1000 "$(playerctl metadata title 2>/dev/null)" "+10 seconds"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
esac
