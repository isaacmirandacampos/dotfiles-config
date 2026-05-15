#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/db.pid"
DB_DIR="$HOME/workspaces/personal/fragmented/databases"

echo $PPID > "$PIDFILE"
cd "$DB_DIR"
hx .
rm -f "$PIDFILE"
