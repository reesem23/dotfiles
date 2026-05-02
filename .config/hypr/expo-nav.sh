#!/bin/bash
# expo-nav.sh — keyboard navigation for hyprexpo
# Moves the cursor over workspace thumbnails; hyprexpo selects
# whichever workspace the cursor is hovering when "select" fires.

COLS=3
MAX_WS=9
ROWS=3
GAP=8   # must match plugin:hyprexpo:gap_size

STATE_FILE="/tmp/hypr-expo-ws"
TIMER_PID_FILE="/tmp/hypr-expo-timer-pid"

kill_timer() {
    if [ -f "$TIMER_PID_FILE" ]; then
        kill "$(cat "$TIMER_PID_FILE")" 2>/dev/null
        rm -f "$TIMER_PID_FILE"
    fi
}

start_timer() {
    kill_timer
    (
        sleep 3
        rm -f "$STATE_FILE"
        hyprctl dispatch hyprexpo:expo select
        hyprctl dispatch submap reset
    ) &
    echo $! > "$TIMER_PID_FILE"
    disown $!
}

move_cursor_to_ws() {
    local ws=$1

    # Logical resolution = physical / scale (floor)
    local mon_w mon_h
    read -r mon_w mon_h < <(
        hyprctl monitors -j | jq -r '.[0] | "\(.width / .scale | floor) \(.height / .scale | floor)"'
    )

    local thumb_w=$(( (mon_w - GAP * (COLS + 1)) / COLS ))
    local thumb_h=$(( (mon_h - GAP * (ROWS + 1)) / ROWS ))

    local col=$(( (ws - 1) % COLS ))
    local row=$(( (ws - 1) / COLS ))

    local x=$(( GAP + col * (thumb_w + GAP) + thumb_w / 2 ))
    local y=$(( GAP + row * (thumb_h + GAP) + thumb_h / 2 ))

    hyprctl dispatch movecursor "$x" "$y"
    echo "$ws" > "$STATE_FILE"
}

get_cur() {
    local ws
    ws=$(cat "$STATE_FILE" 2>/dev/null)
    if [ -z "$ws" ]; then
        ws=$(hyprctl activeworkspace -j | jq -r '.id')
    fi
    echo "$ws"
}

case "$1" in
    open)
        cur=$(hyprctl activeworkspace -j | jq -r '.id')
        (( cur < 1 ))      && cur=1
        (( cur > MAX_WS )) && cur=$MAX_WS
        move_cursor_to_ws "$cur"
        start_timer
        ;;

    left|right|up|down)
        cur=$(get_cur)
        cur_col=$(( (cur - 1) % COLS ))
        cur_row=$(( (cur - 1) / COLS ))
        new=$cur

        case "$1" in
            left)
                (( cur_col > 0 ))           && new=$(( cur - 1 ))
                ;;
            right)
                (( cur_col < COLS - 1 ))    && new=$(( cur + 1 ))
                ;;
            up)
                (( cur_row > 0 ))           && new=$(( cur - COLS ))
                ;;
            down)
                if (( cur_row < ROWS - 1 )); then
                    new=$(( cur + COLS ))
                    (( new > MAX_WS ))      && new=$cur
                fi
                ;;
        esac

        move_cursor_to_ws "$new"
        start_timer
        ;;

    enter)
        kill_timer
        rm -f "$STATE_FILE"
        hyprctl dispatch hyprexpo:expo select
        hyprctl dispatch submap reset
        ;;

    close)
        kill_timer
        rm -f "$STATE_FILE"
        hyprctl dispatch hyprexpo:expo close
        hyprctl dispatch submap reset
        ;;
esac
