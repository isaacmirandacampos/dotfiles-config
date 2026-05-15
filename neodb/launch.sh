#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/db.pid"
DB_DIR="$HOME/workspaces/personal/fragmented/databases"
GHOSTTY="/Applications/Ghostty.app/Contents/MacOS/ghostty"

# If already running, focus it
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  if kill -0 "$PID" 2>/dev/null && ps -p "$PID" -o comm= 2>/dev/null | grep -q ghostty; then
    osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" 2>/dev/null || true
    exit 0
  fi
  rm -f "$PIDFILE"
fi

mkdir -p "$DB_DIR"

DOTFILES_DIR="$HOME/dotfiles-config"
RUN_SCRIPT="$DOTFILES_DIR/neodb/run.sh"

"$GHOSTTY" \
  --title="db" \
  --working-directory="$DB_DIR" \
  -e "$RUN_SCRIPT"
