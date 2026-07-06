#!/bin/bash

INACTIVE=0.8
ACTIVE=1.0

swaymsg -t subscribe -m '["window"]' | jq --unbuffered -r '.change' | while read -r change; do
    if [[ "$change" == "focus" ]]; then
        # 1. קודם כל דואגים שהחלון הנוכחי שבפוקוס יהיה אטום לחלוטין
        swaymsg "[focused] opacity $ACTIVE" > /dev/null 2>&1
        
        # 2. עוברים על עץ החלונות, שולפים רק את אלו שלא בפוקוס, ומחילים עליהם שקיפות
        swaymsg -t get_tree | \
        jq -r '.. | objects | select(.type == "con" or .type == "floating_con") | select(.focused == false and .id != null) | .id' | \
        xargs -I {} swaymsg "[con_id={}] opacity $INACTIVE" > /dev/null 2>&1
    fi
done
