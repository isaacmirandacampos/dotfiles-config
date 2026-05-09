#!/usr/bin/env bash
set -euo pipefail

convert_svg_to_icns() {
  local svg="$1"
  local icns="$2"
  local tmpdir
  tmpdir=$(mktemp -d)
  local iconset="$tmpdir/icon.iconset"
  mkdir -p "$iconset"

  for size in 16 32 128 256 512; do
    rsvg-convert -w "$size" -h "$size" "$svg" -o "$iconset/icon_${size}x${size}.png"
    double=$((size * 2))
    rsvg-convert -w "$double" -h "$double" "$svg" -o "$iconset/icon_${size}x${size}@2x.png"
  done

  iconutil -c icns "$iconset" -o "$icns"
  rm -rf "$tmpdir"
  echo "Created: $icns"
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ntn (NeoNotes)
convert_svg_to_icns "$SCRIPT_DIR/neonotes/icon.svg" "$SCRIPT_DIR/neonotes/applet.icns"
# dbn (NeoDB)
convert_svg_to_icns "$SCRIPT_DIR/harlequin/icon.svg" "$SCRIPT_DIR/harlequin/applet.icns"

# Copy to .app bundles
cp "$SCRIPT_DIR/neonotes/applet.icns" "/Applications/NeoNotes.app/Contents/Resources/applet.icns"
cp "$SCRIPT_DIR/harlequin/applet.icns" "/Applications/NeoDB.app/Contents/Resources/applet.icns"

# Touch apps to refresh icon cache
touch "/Applications/NeoNotes.app"
touch "/Applications/NeoDB.app"

echo "Done! Icons applied. You may need to restart Dock: killall Dock"
