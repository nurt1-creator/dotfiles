#!/bin/bash

shutdown="  Power Off"
reboot="  Restart" 
suspend=" Suspend"
logout="  Log Out"
lock="  Lock"

options="$shutdown\n$reboot\n$suspend\n$logout\n$lock"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme $HOME/.config/rofi/apps.rasi)

case $chosen in
    $shutdown)
        systemctl poweroff ;;
    $reboot)
        systemctl reboot ;;
    $suspend)
        swaylock && sleep 2s && systemctl suspend ;;
    $logout)
	hyprctl dispatch exit ;;
    $lock)
        swaylock ;;
esac
