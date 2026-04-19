#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/harlequin.pid"
DB_DIR="$HOME/workspaces/personal/fragmented/databases"
KITTY="/Applications/kitty.app/Contents/MacOS/kitty"
if [ ! -x "$KITTY" ]; then
  KITTY="/opt/homebrew/bin/kitty"
fi

HARLEQUIN="$HOME/.local/bin/harlequin"
if [ ! -x "$HARLEQUIN" ]; then
  HARLEQUIN="/opt/homebrew/bin/harlequin"
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

mkdir -p "$DB_DIR"

"$KITTY" \
  --title "Harlequin" \
  --override "background_opacity=0.3" \
  --override "tab_bar_style=hidden" \
  --directory "$DB_DIR" \
  bash -c "echo \$PPID > $PIDFILE; $HARLEQUIN; rm -f $PIDFILE; kill \$PPID 2>/dev/null" &

exit 0
