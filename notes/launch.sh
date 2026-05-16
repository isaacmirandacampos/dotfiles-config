#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/notes.pid"
BRAIN_DIR="$HOME/workspaces/personal/Brain"
GHOSTTY="/Applications/Ghostty.app/Contents/MacOS/ghostty"

mkdir -p "$BRAIN_DIR"

# If already running, focus it
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  if kill -0 "$PID" 2>/dev/null && ps -p "$PID" -o comm= 2>/dev/null | grep -q ghostty; then
    osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" 2>/dev/null || true
    exit 0
  fi
  rm -f "$PIDFILE"
fi

DOTFILES_DIR="$HOME/dotfiles-config"
RUN_SCRIPT="$DOTFILES_DIR/notes/run.sh"

"$GHOSTTY" \
  --title="notes" \
  --working-directory="$BRAIN_DIR" \
  -e "$RUN_SCRIPT"
