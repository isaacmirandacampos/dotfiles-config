#!/usr/bin/env bash
set -euo pipefail

PIDFILE="/tmp/neonotes.pid"
NOTES_DIR="$HOME/workspaces/personal/fragmented/notes/inbox"
TODAY="$(date +%Y-%m-%d)"
FILE="$NOTES_DIR/$TODAY.md"

echo $PPID > "$PIDFILE"
/opt/homebrew/bin/nvim "+cd $NOTES_DIR" "$FILE"
rm -f "$PIDFILE"
kill $PPID 2>/dev/null
