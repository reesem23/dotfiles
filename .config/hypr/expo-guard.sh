#!/bin/bash
# expo-guard.sh — reset expo submap if hyprexpo closes without keyboard dismissal
# When expo is closed by mouse click, expo-nav.sh is never called, so the submap
# stays stuck in "expo" mode. This watcher detects it via Hyprland events.

STATE_FILE="/tmp/hypr-expo-ws"
SOCKET="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -u "UNIX-CONNECT:$SOCKET" - 2>/dev/null | while IFS= read -r event; do
    case "$event" in
        workspace>>*|activewindow>>*)
            if [ -f "$STATE_FILE" ]; then
                rm -f "$STATE_FILE"
                hyprctl dispatch submap reset 2>/dev/null
            fi
            ;;
    esac
done
