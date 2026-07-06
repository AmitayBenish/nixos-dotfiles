
#!/bin/sh

# קובץ זמני ב-RAM
LANG_FILE="/tmp/sway_lang"

get_lang() {
    swaymsg -t get_inputs | awk -F'"' '/xkb_active_layout_name/ {print ($4 == "Hebrew" ? "he" : "en"); exit}'
}

# עדכון ראשוני
get_lang > "$LANG_FILE"

# האזנה לאירועים - אפס מאמץ למעבד
swaymsg -m -t subscribe '["input"]' | while read -r event; do
    get_lang > "$LANG_FILE"
    # שולח אות (Signal) ל-Waybar או ללולאה הראשית להתעדכן מיד (אופציונלי)
    # pkill -RTMIN+1 waybar 
done
