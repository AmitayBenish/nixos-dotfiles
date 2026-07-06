#!/bin/bash

# הפניית כל הפלט (הרגיל ושגיאות) לקובץ לוג זמני


# הפעלת הנעילה ברקע
swaylock -f

# המתנה
sleep 15


# הסרנו את הדגל -x כדי למנוע פספוסים בזיהוי השם
if pgrep swaylock > /dev/null; then
    systemctl suspend
fi
