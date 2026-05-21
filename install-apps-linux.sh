#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPS_DIR="$HOME/.local/share/applications"
ICONS_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"

mkdir -p "$APPS_DIR" "$ICONS_DIR"

# create_app NAME DESKTOP_BASE ICON_NAME SOURCE_DIR ICON_SRC
#   DESKTOP_BASE = filename (no extension) used for the .desktop entry
#   ICON_NAME    = Icon= value (also the installed PNG basename when ICON_SRC is set)
#   ICON_SRC     = path to a PNG to install, or "" to rely on a system-theme icon named ICON_NAME
create_app() {
  local name="$1"
  local desktop_base="$2"
  local icon_name="$3"
  local source_dir="$4"
  local icon_src="$5"

  local launcher="$source_dir/launch.sh"
  chmod +x "$launcher"

  if [ -n "$icon_src" ] && [ -f "$icon_src" ]; then
    cp "$icon_src" "$ICONS_DIR/$icon_name.png"
  fi

  local desktop_file="$APPS_DIR/$desktop_base.desktop"
  cat > "$desktop_file" <<DESKTOP
[Desktop Entry]
Type=Application
Name=$name
Exec=$launcher
Icon=$icon_name
Terminal=false
Categories=Utility;
StartupNotify=true
StartupWMClass=com.mitchellh.ghostty.$(echo "$name" | tr '[:upper:]' '[:lower:]')
DESKTOP

  echo "✓ $name → $desktop_file"
}

create_app "notes" "notes-app" "notes-app" "$SCRIPT_DIR/notes" "$SCRIPT_DIR/notes/icon.png"
create_app "db"    "db-app"    "db-app"    "$SCRIPT_DIR/db"    "$SCRIPT_DIR/db/icon.png"
# yazi: use the entry shipped by the yazi package (/usr/share/applications/yazi.desktop) instead of wrapping it

# Refresh desktop entry / icon caches (best effort; ignored if tools absent)
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$APPS_DIR" >/dev/null 2>&1 || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -f -t "$HOME/.local/share/icons/hicolor" >/dev/null 2>&1 || true
fi

echo ""
echo "Apps instalados em $APPS_DIR/"
echo "Abra o Walker/launcher (Super) e busque por notes, db ou yazi."
