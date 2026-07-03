#!/bin/bash
brightnessctl set "$@"
brightness=$(brightnessctl info | grep -oP '\(\K[^%]+(?=%\))')
notify-send -h string:x-canonical-private-synchronous:brightness "Brightness: $brightness%" -h int:value:"$brightness" -i display-brightness
