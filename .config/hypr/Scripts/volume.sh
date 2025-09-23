#!/bin/bash

MAX_VOLUME=100
STEP=5

get_sink_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | awk '{print $5}' | sed 's/%//' || echo "0"
}

get_sink_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | awk '{print $2}' || echo "no"
}

get_source_volume() {
    pactl get-source-volume @DEFAULT_SOURCE@ 2>/dev/null | awk '{print $5}' | sed 's/%//' || echo "0"
}

get_source_mute() {
    pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | awk '{print $2}' || echo "no"
}

case $1 in
    "up")
        muted=$(get_sink_mute)
        if [ "$muted" = "yes" ]; then
            pactl set-sink-mute @DEFAULT_SINK@ toggle
        fi
        current=$(get_sink_volume)
        if [ "$current" -lt $MAX_VOLUME ]; then
            new_volume=$((current + STEP))
            [ "$new_volume" -gt $MAX_VOLUME ] && new_volume=$MAX_VOLUME
            pactl set-sink-volume @DEFAULT_SINK@ ${new_volume}%
	    swaync-client -C
	    notify-send "Volume: ${new_volume}%"
        fi
        ;;
    "down")
        current=$(get_sink_volume)
        new_volume=$((current - STEP))
        [ "$new_volume" -lt 0 ] && new_volume=0
        pactl set-sink-volume @DEFAULT_SINK@ ${new_volume}% 
	swaync-client -C
	notify-send "Volume: ${new_volume}%"
        ;;
    "mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    "mic-up")
        muted=$(get_source_mute)
        if [ "$muted" = "yes" ]; then
            pactl set-source-mute @DEFAULT_SOURCE@ 0
        fi
        current=$(get_source_volume)
        if [ "$current" -lt $MAX_VOLUME ]; then
            new_volume=$((current + STEP))
            [ "$new_volume" -gt $MAX_VOLUME ] && new_volume=$MAX_VOLUME
            pactl set-source-volume @DEFAULT_SOURCE@ ${new_volume}%
        fi
        ;;
    "mic-down")
        current=$(get_source_volume)
        new_volume=$((current - STEP))
        [ "$new_volume" -lt 0 ] && new_volume=0
        pactl set-source-volume @DEFAULT_SOURCE@ ${new_volume}%
        ;;
    "mic-mute")
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        ;;
    *)
        echo "Usage: $0 {up|down|mute|mic-up|mic-down|mic-mute}"
        exit 1
        ;;
esac
