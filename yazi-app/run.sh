#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/share/mise/shims:$HOME/go/bin:/opt/homebrew/bin:$HOME/.local/bin:$PATH"

PIDFILE="/tmp/yazi.pid"

echo $PPID > "$PIDFILE"
cd "$HOME"
yazi
rm -f "$PIDFILE"
