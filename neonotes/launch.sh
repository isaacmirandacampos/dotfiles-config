#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/neonotes.pid"
NOTES_DIR="$HOME/workspaces/personal/fragmented/notes/inbox"
mkdir -p "$NOTES_DIR"

TODAY="$(date +%Y-%m-%d)"
FILE="$NOTES_DIR/$TODAY.md"

if [ ! -f "$FILE" ]; then
  echo "# $TODAY" > "$FILE"
  echo "" >> "$FILE"
fi

KITTY="/Applications/kitty.app/Contents/MacOS/kitty"
if [ ! -x "$KITTY" ]; then
  KITTY="/opt/homebrew/bin/kitty"
fi

# If already running, focus it
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  if kill -0 "$PID" 2>/dev/null; then
    osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" 2>/dev/null
    exit 0
  fi
  rm -f "$PIDFILE"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

"$KITTY" \
  --title "NeoNotes" \
  --override "background_opacity=0.3" \
  --override "tab_bar_style=hidden" \
  --directory "$NOTES_DIR" \
  "$SCRIPT_DIR/run.sh" &

exit 0
