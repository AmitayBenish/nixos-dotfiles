
# האתחול הזה ירוץ פעם אחת בלבד ברגע שתעשה source מהסקריפט הראשי
read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
PREV_IDLE=$((idle + iowait))
PREV_NON_IDLE=$((user + nice + system + irq + softirq + steal + guest + guest_nice))
PREV_TOTAL=$((PREV_IDLE + PREV_NON_IDLE))

get_cpu_percentage() {
    # קריאת נתונים חדשים
    read -r cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    
    local curr_idle=$((idle + iowait))
    local curr_non_idle=$((user + nice + system + irq + softirq + steal + guest + guest_nice))
    local curr_total=$((curr_idle + curr_non_idle))

    # חישוב מול המשתנים הגלובליים שלנו
    local total_delta=$((curr_total - PREV_TOTAL))
    local idle_delta=$((curr_idle - PREV_IDLE))

    if [[ $total_delta -gt 0 ]]; then
        local percentage=$(((total_delta - idle_delta) * 100 / total_delta))
    else
        local percentage=0
    fi

    echo "CPU:$percentage%"

    # עדכון המשתנים הגלובליים (שחיים בזיכרון המשותף!) לפעם הבאה
    PREV_IDLE=$curr_idle
    PREV_TOTAL=$curr_total
}
