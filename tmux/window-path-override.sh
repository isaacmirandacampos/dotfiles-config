#!/usr/bin/env bash
# Replaces #W (command name) with #{b:pane_current_path} (directory basename)
# in tokyo-night's window formats, preserving all styling.

current="$(tmux show -gv window-status-current-format)"
normal="$(tmux show -gv window-status-format)"

replacement='#{b:pane_current_path}'

tmux set -g window-status-current-format "$(echo "$current" | sed "s|#W|$replacement|g")"
tmux set -g window-status-format "$(echo "$normal" | sed "s|#W|$replacement|g")"
