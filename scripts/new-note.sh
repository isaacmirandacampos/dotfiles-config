#!/usr/bin/env bash
set -euo pipefail

BRAIN_DIR="$HOME/workspaces/personal/Brain"
TEMPLATES_DIR="$BRAIN_DIR/templates"

TYPE="${1:-permanent}"
TITLE="${2:-}"

case "$TYPE" in
  daily)
    DATE="$(date +%Y-%m-%d)"
    TIME="$(date +%H:%M)"
    FILE="$BRAIN_DIR/daily-notes/$DATE.md"
    if [ ! -f "$FILE" ]; then
      sed -e "s/{{title}}/$DATE/g" \
          -e "s/{{date}}/$DATE/g" \
          -e "s/{{time}}/$TIME/g" \
          "$TEMPLATES_DIR/daily_template.md" > "$FILE"
    fi
    echo "$FILE"
    ;;
  permanent|fleeting|references)
    if [ -z "$TITLE" ]; then
      printf "Título da nota: " >&2
      read -r TITLE
    fi
    if [ -z "$TITLE" ]; then
      echo "Título não pode ser vazio" >&2
      exit 1
    fi
    FILE="$BRAIN_DIR/$TITLE.md"
    if [ ! -f "$FILE" ]; then
      TEMPLATE="$TEMPLATES_DIR/$TYPE.md"
      if [ ! -f "$TEMPLATE" ]; then
        TEMPLATE="$TEMPLATES_DIR/permanent.md"
      fi
      DATE="$(date +%Y-%m-%d)"
      TIME="$(date +%H:%M)"
      sed -e "s/{{title}}/$TITLE/g" \
          -e "s/{{date}}/$DATE/g" \
          -e "s/{{time}}/$TIME/g" \
          "$TEMPLATE" > "$FILE"
    fi
    echo "$FILE"
    ;;
  *)
    echo "Tipo inválido: $TYPE (use: permanent, fleeting, references, daily)" >&2
    exit 1
    ;;
esac
