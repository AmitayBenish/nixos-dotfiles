
#!/bin/bash
source "$HOME/.config/sway/cpu_utilz.sh"
counter=0
NET="󰖟"

while true; do
  # 1. קריאת סוללה (יעיל, ישירות מהמערכת)
  read -r BAT < /sys/class/power_supply/BAT0/capacity
  read -r STATUS < /sys/class/power_supply/BAT0/status
  [ "$STATUS" = "Discharging" ] && STATUS="" || STATUS="Charging:"

  # 2. קריאת שפה מהקובץ הזמני (מהיר ובזכרון ה-RAM)
  if [ -f /tmp/sway_lang ]; then
    LANG=$(cat /tmp/sway_lang)
  else
    LANG="en"
  fi

  # 3. בדיקת רשת - פעם ב-30 שניות בלבד!
  if [ $((counter % 30)) -eq 0 ]; then
    if ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1; then
      NET="󰖟"
    else
      NET=""
    fi
  fi

  # 4. שעון
  DATE=$(date +'%Y-%m-%d %X')

  CPU_TEXT=$(get_cpu_percentage)

  # פלט סופי
  echo "$LANG $CPU_TEXT $NET $STATUS$BAT% $DATE"

  counter=$((counter + 1))
  sleep 1 # עכשיו ה-sleep 1 הזה כמעט ולא עולה כלום, כי המעבד לא עושה כלום!
done
