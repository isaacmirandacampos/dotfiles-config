#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/notes.pid"
NOTES_DIR="$HOME/workspaces/personal/fragmented/notes/inbox"
TODAY="$(date +%Y-%m-%d)"
FILE="$NOTES_DIR/$TODAY.md"

echo $PPID > "$PIDFILE"
cd "$NOTES_DIR"
hx "$FILE"
rm -f "$PIDFILE"
