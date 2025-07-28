#!/bin/bash

# Skitty Notes Layout - Adds floating notes to existing tmux session
# This script enhances your current session with floating nvim notes

NOTES_FILE="$HOME/workspaces/personal/Brain/current.md"

tmux display-popup -E -h 80% -w 45% -x 100% -y 0 "export NEOVIM_MODE=skitty && nvim '$NOTES_FILE'"
