#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$HOME/.local/bin:$PATH"

PIDFILE="/tmp/notes.pid"
BRAIN_DIR="$HOME/workspaces/personal/Brain"
SCRIPTS_DIR="$HOME/dotfiles-config/scripts"
SESSION="notes"

# Helix is `hx` on macOS (brew) but `helix` on Arch
HX_BIN="$(command -v hx || command -v helix)"

echo $PPID > "$PIDFILE"

# Create daily note
FILE="$($SCRIPTS_DIR/new-note.sh daily)"

# Attach to existing session or create new one
if tmux has-session -t "$SESSION" 2>/dev/null; then
  tmux attach-session -t "$SESSION"
else
  tmux new-session -s "$SESSION" -c "$BRAIN_DIR" "$HX_BIN \"$FILE\""
fi

rm -f "$PIDFILE"
