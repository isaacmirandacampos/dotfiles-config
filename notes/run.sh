#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/notes.pid"
BRAIN_DIR="$HOME/workspaces/personal/Brain"
SCRIPTS_DIR="$HOME/dotfiles-config/scripts"

echo $PPID > "$PIDFILE"
cd "$BRAIN_DIR"

# Cria daily note e abre
FILE="$($SCRIPTS_DIR/new-note.sh daily)"
hx "$FILE"

rm -f "$PIDFILE"
