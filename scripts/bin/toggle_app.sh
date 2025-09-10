#!/usr/bin/env bash

# === Paths ===
YABAI="/opt/homebrew/Cellar/yabai/7.1.15/bin/yabai"
JQ="/opt/homebrew/Cellar/jq/1.8.1/bin/jq"
LOG="/tmp/skhd_toggle.log"

APP="$1"
POS_FILE="/tmp/toggle_app_${APP}_frame.json"  # store frame info for restore

echo "$(date '+%H:%M:%S') - Toggling $APP" >> "$LOG"

# === 1. Launch if not running ===
if ! pgrep -x "$APP" >/dev/null; then
    echo "$(date '+%H:%M:%S') - $APP not running, launching..." >> "$LOG"
    open -a "$APP"
    exit 0
fi

# === 2. Get first window of the app (handles invisible chars) ===
WIN_ID=$($YABAI -m query --windows | $JQ -r --arg app "$APP" \
  '.[] | select(.app | contains($app)) | .id' | head -n1)

# If no window exists, just open app
if [ -z "$WIN_ID" ]; then
    echo "$(date '+%H:%M:%S') - No window found, opening $APP" >> "$LOG"
    open -a "$APP"
    exit 0
fi

# === 3. Check if minimized ===
IS_MINIMIZED=$($YABAI -m query --windows --window "$WIN_ID" | $JQ -r '.["is-minimized"]')
echo "$(date '+%H:%M:%S') - WIN_ID=$WIN_ID IS_MINIMIZED=$IS_MINIMIZED" >> "$LOG"

# === 4. Toggle minimize/restore with frame save/restore ===
if [ "$IS_MINIMIZED" = "true" ]; then
    echo "$(date '+%H:%M:%S') - Restoring $APP window $WIN_ID" >> "$LOG"

    # Restore window
    $YABAI -m window "$WIN_ID" --deminimize

    # Restore saved frame if exists
    if [ -f "$POS_FILE" ]; then
        FRAME=$(cat "$POS_FILE")
        X=$(echo "$FRAME" | $JQ '.x')
        Y=$(echo "$FRAME" | $JQ '.y')
        W=$(echo "$FRAME" | $JQ '.w')
        H=$(echo "$FRAME" | $JQ '.h')

        $YABAI -m window "$WIN_ID" --move abs:$X:$Y
        $YABAI -m window "$WIN_ID" --resize abs:$W:$H
    fi

# $YABAI -m window --focus "$WIN_ID"

else
    echo "$(date '+%H:%M:%S') - Minimizing $APP window $WIN_ID" >> "$LOG"

    # Save current frame before minimizing
    $YABAI -m query --windows --window "$WIN_ID" | $JQ '.frame' > "$POS_FILE"

    $YABAI -m window "$WIN_ID" --minimize
fi
