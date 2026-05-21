#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$HOME/.local/bin:$PATH"

PIDFILE="/tmp/db.pid"
DB_DIR="$HOME/workspaces/personal/Brain/services/db"

NVIM_BIN="$(command -v nvim)"

echo $PPID > "$PIDFILE"
NEOVIM_MODE=neodb "$NVIM_BIN" "+cd $DB_DIR" "+DBUI"
rm -f "$PIDFILE"
