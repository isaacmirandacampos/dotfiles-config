#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/db.pid"
DB_DIR="$HOME/workspaces/personal/Brain/services/db"

echo $PPID > "$PIDFILE"
NEOVIM_MODE=neodb /opt/homebrew/bin/nvim "+cd $DB_DIR" "+DBUI"
rm -f "$PIDFILE"
