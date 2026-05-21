#!/usr/bin/env bash
set -euo pipefail

APP_NAME="yazi"
PIDFILE="/tmp/${APP_NAME}.pid"

if [[ "$OSTYPE" == "darwin"* ]]; then
  GHOSTTY="/Applications/Ghostty.app/Contents/MacOS/ghostty"
  focus_existing() {
    osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $1) to true" 2>/dev/null || true
  }
  ghostty_class_arg=()
else
  GHOSTTY="$(command -v ghostty)"
  focus_existing() {
    hyprctl dispatch focuswindow "title:^(${APP_NAME})$" >/dev/null 2>&1 || true
  }
  ghostty_class_arg=(--class="com.mitchellh.ghostty.${APP_NAME}")
fi

# If already running, focus it
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  if kill -0 "$PID" 2>/dev/null && ps -p "$PID" -o comm= 2>/dev/null | grep -q ghostty; then
    focus_existing "$PID"
    exit 0
  fi
  rm -f "$PIDFILE"
fi

DOTFILES_DIR="$HOME/dotfiles-config"
RUN_SCRIPT="$DOTFILES_DIR/yazi-app/run.sh"

"$GHOSTTY" \
  --title="$APP_NAME" \
  "${ghostty_class_arg[@]}" \
  --working-directory="$HOME" \
  -e "$RUN_SCRIPT"
