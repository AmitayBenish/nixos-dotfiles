#!/usr/bin/env bash

# פונקציה שמטפלת בהדלקה/כיבוי לפי מצב המכסה
update_lid_state() {
    if grep -q closed /proc/acpi/button/lid/LID/state; then
        niri msg output eDP-1 off
    else
        niri msg output eDP-1 on
    fi
}

# 1. מריצים פעם אחת מיד עם הפעלת הסקריפט (כדי לטפל במצב ההתחלתי)
update_lid_state

# 2. מאזינים לאירועי חומרה כל הזמן ברקע
acpi_listen | while read -r event; do
    # בודקים אם האירוע קשור למכסה של הלפטופ
    if [[ "$event" == *"button/lid"* ]]; then
        update_lid_state
    fi
done
