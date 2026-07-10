#!/bin/bash
TARGET_MONITOR=${1:-eDP-1}
mmsg watch tags "$TARGET_MONITOR" | jq --unbuffered -r '.tags[] | select(.is_active) | .layout' | while read -r CURRENT_TILING; do
  echo "$CURRENT_TILING"
done
