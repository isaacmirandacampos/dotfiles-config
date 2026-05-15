#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPS_DIR="$HOME/Applications"
mkdir -p "$APPS_DIR"

# Remove old apps
rm -rf "$APPS_DIR/NeoNotes.app" "$APPS_DIR/NeoDB.app"

create_app() {
  local name="$1"
  local bundle_id="$2"
  local source_dir="$3"
  local app_path="$APPS_DIR/$name.app"

  rm -rf "$app_path"
  mkdir -p "$app_path/Contents/MacOS"
  mkdir -p "$app_path/Contents/Resources"

  cp "$source_dir/applet.icns" "$app_path/Contents/Resources/applet.icns"
  cp "$source_dir/launch.sh" "$app_path/Contents/MacOS/launcher"
  chmod +x "$app_path/Contents/MacOS/launcher"

  cat > "$app_path/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key>
  <string>$name</string>
  <key>CFBundleIdentifier</key>
  <string>$bundle_id</string>
  <key>CFBundleExecutable</key>
  <string>launcher</string>
  <key>CFBundleIconFile</key>
  <string>applet.icns</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleVersion</key>
  <string>1.0</string>
  <key>LSUIElement</key>
  <false/>
</dict>
</plist>
PLIST

  echo "✓ $name.app instalado em $app_path"
}

create_app "Notes" "com.isaacdmcampos.notes" "$SCRIPT_DIR/neonotes"
create_app "DB" "com.isaacdmcampos.db" "$SCRIPT_DIR/neodb"

echo ""
echo "Apps instalados em $APPS_DIR/"
echo "Abra o Spotlight (Cmd+Space) e busque por Notes ou DB."
