#!/usr/bin/env bash
set -euo pipefail

# Requires AeroSpace CLI available on PATH as `aerospace`.
# Behavior:
# - If there is no existing Kitty window, move this window to workspace 2 (tiling)
# - If there is an existing Kitty window, float this new window in current workspace

APP_ID="net.kovidgoyal.kitty"

# Ensure AeroSpace CLI is available; if not, do nothing
if ! command -v aerospace >/dev/null 2>&1; then
  exit 0
fi

# Count current Kitty windows using macOS System Events by bundle id
kitty_count=$(osascript -e 'tell application "System Events" to set ks to (processes whose bundle identifier is "net.kovidgoyal.kitty")
if (count of ks) is 0 then return 0
return count of windows of item 1 of ks' 2>/dev/null || echo 0)

if [ -z "${kitty_count}" ] || ! [[ ${kitty_count} =~ ^[0-9]+$ ]]; then
  kitty_count=0
fi

# Treat exactly 1 window as the first Kitty instance
if [ "${kitty_count}" -eq 1 ]; then
  # First Kitty: ensure tiling and send to workspace 2
  aerospace layout tiling || true
  aerospace move-node-to-workspace 2 || true
else
  # Subsequent Kitty: keep in current workspace and float
  aerospace layout floating || true
fi

exit 0


