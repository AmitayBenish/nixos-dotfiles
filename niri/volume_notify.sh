#!/bin/bash

# עדכון הווליום (למשל: 5%+)
pamixer "$@"

# קבלת הערך הנוכחי
volume=$(pamixer --get-volume)
is_muted=$(pamixer --get-mute)

if [ "$is_muted" = "true" ]; then
    notify-send -h string:x-canonical-private-synchronous:volume "Muted" -i audio-volume-muted
else
    notify-send -h string:x-canonical-private-synchronous:volume "Volume: $volume%" -h int:value:"$volume" -i audio-volume-high
fi
