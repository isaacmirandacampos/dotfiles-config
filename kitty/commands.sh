#!/usr/bin/env bash
set -euo pipefail

ITEMS=(
  "Copiar último comando"
  "Reload configs"
  "Abrir output no nvim"
)

selected=$(printf '%s\n' "${ITEMS[@]}" | fzf --prompt="kitty> ")
[[ -z "$selected" ]] && exit 0

get_last_output() {
  tmux capture-pane -p -S -500 | awk '
    /^❯ / {
      prev = cur
      cur = $0 "\n"
      next
    }
    { cur = cur $0 "\n" }
    END {
      n = split(prev, lines, "\n")
      while (n > 0 && lines[n] == "") n--
      if (n > 0) n--
      result = ""
      for (i = 1; i <= n; i++) result = result lines[i] "\n"
      printf "%s", result
    }
  '
}

case "$selected" in
"Copiar último comando")
  get_last_output | pbcopy
  echo "Último comando copiado."
  ;;
"Reload configs")
  kill -SIGUSR1 "$(pgrep -x kitty | head -1)" 2>/dev/null && echo "kitty reloaded."
  source ~/.zshrc 2>/dev/null && echo "zshrc reloaded."
  tmux source-file ~/.tmux.conf 2>/dev/null && echo "tmux reloaded."
  ;;
"Abrir output no nvim")
  get_last_output | nvim -c "setlocal buftype=nofile bufhidden=wipe noswapfile" -
  ;;
esac
