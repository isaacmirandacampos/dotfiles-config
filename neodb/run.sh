#!/usr/bin/env bash
set -euo pipefail

export PATH="/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/neodb.pid"
DB_DIR="$HOME/workspaces/personal/fragmented/databases"

echo $PPID > "$PIDFILE"
NEOVIM_MODE=neodb /opt/homebrew/bin/nvim "+cd $DB_DIR" "+DBUI"
rm -f "$PIDFILE"
kill $PPID 2>/dev/null
