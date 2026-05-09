#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/neodb.pid"
DB_DIR="$HOME/workspaces/personal/fragmented/databases"
KITTY="/Applications/kitty.app/Contents/MacOS/kitty"
if [ ! -x "$KITTY" ]; then
  KITTY="/opt/homebrew/bin/kitty"
fi

# If already running, focus it
if [ -f "$PIDFILE" ]; then
  PID=$(cat "$PIDFILE")
  if kill -0 "$PID" 2>/dev/null && ps -p "$PID" -o comm= 2>/dev/null | grep -q kitty; then
    osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $PID) to true" 2>/dev/null || true
    exit 0
  fi
  rm -f "$PIDFILE"
fi

mkdir -p "$DB_DIR"

# Resolve run.sh path relative to dotfiles, not the .app bundle
DOTFILES_DIR="$HOME/dotfiles-config"
RUN_SCRIPT="$DOTFILES_DIR/neodb/run.sh"

"$KITTY" \
  --title "dbn" \
  --override "background_opacity=0.3" \
  --override "tab_bar_style=hidden" \
  --directory "$DB_DIR" \
  "$RUN_SCRIPT"
