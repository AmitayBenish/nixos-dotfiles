
#!/bin/usr/env bash
# מניח שסקריפט ההאזנה שלך שומר את השפה המעודכנת לקובץ 
slstatus -s | while read -r status_line; do
    CURRENT_LANG=$(cat /tmp/sway_lang)
    echo "$CURRENT_LANG  $status_line"
done
