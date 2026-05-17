#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/notes.pid"
BRAIN_DIR="$HOME/workspaces/personal/Brain"
SCRIPTS_DIR="$HOME/dotfiles-config/scripts"
SESSION="notes"

echo $PPID > "$PIDFILE"

# Create daily note
FILE="$($SCRIPTS_DIR/new-note.sh daily)"

# Attach to existing session or create new one
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach-session -t "$SESSION"
else
  tmux new-session -s "$SESSION" -c "$BRAIN_DIR" "hx \"$FILE\""
fi

rm -f "$PIDFILE"
