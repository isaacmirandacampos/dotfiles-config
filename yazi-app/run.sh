#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$PATH"

PIDFILE="/tmp/finder.pid"

echo $PPID > "$PIDFILE"
cd "$HOME"
yazi
rm -f "$PIDFILE"
