# ── History ──────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ── Options ─────────────────────────────────────────────
setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# ── Key bindings (emacs-style) ──────────────────────────
bindkey -e
bindkey '^[[H'    beginning-of-line      # Home
bindkey '^[[F'    end-of-line            # End
bindkey '^[[3~'   delete-char            # Delete
bindkey '^[[1;5C' forward-word           # Ctrl+Right
bindkey '^[[1;5D' backward-word          # Ctrl+Left
bindkey '^[f'     forward-word           # Alt+Right
bindkey '^[b'     backward-word          # Alt+Left

# ── History search (Up/Down match prefix) ──────────────
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end  # Up
bindkey '^[[B' history-beginning-search-forward-end    # Down

# ── Edit command line in nvim (Ctrl+E) ─────────────────
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^g' edit-command-line

# ── Completions ─────────────────────────────────────────
autoload -Uz compinit
compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ── Homebrew ────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── Editor ──────────────────────────────────────────────
export EDITOR=nvim

# ── PATH ────────────────────────────────────────────────
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/curl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/curl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Go (GOPATH for compiled binaries)
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# libpq
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# bun
export PATH="$HOME/.bun/bin:$PATH"

# tmux-sessionizer
export PATH="$PATH:$HOME/.config/tmux/"

# ── Aliases ─────────────────────────────────────────────
alias lg='lazygit'
alias ld='lazydocker'
alias t='tmux-sessionizer'
alias s='yazi'
alias ck='$HOME/dotfiles-config/kitty/commands.sh'
alias venv='python3 -m venv .venv && source .venv/bin/activate'

# ── FZF ─────────────────────────────────────────────────
export FZF_DEFAULT_OPTS=" \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#3e4452 \
  --color=bg:#282c34 \
  --color=border:#3e4452 \
  --color=fg:#abb2bf \
  --color=gutter:#282c34 \
  --color=header:#e06c75 \
  --color=hl+:#e06c75 \
  --color=hl:#e06c75 \
  --color=info:#5c6370 \
  --color=marker:#e06c75 \
  --color=pointer:#e06c75 \
  --color=prompt:#e06c75 \
  --color=query:#abb2bf:regular \
  --color=scrollbar:#3e4452 \
  --color=separator:#3e4452 \
  --color=spinner:#e06c75"

source <(fzf --zsh)

# ── Zoxide ──────────────────────────────────────────────
eval "$(zoxide init zsh --cmd cd)"
export _ZO_DATA_DIR="$HOME/.local/share/zoxide/"

# ── Sheldon (plugins) ──────────────────────────────────
eval "$(sheldon source)"

# ── Mise (runtime manager) ─────────────────────────────
eval "$(mise activate zsh)"

# ── tmux-sessionizer (Ctrl+F) ──────────────────────────
bindkey -s '^f' 'tmux-sessionizer\n'

# ── Starship (prompt) ──────────────────────────────────
eval "$(starship init zsh)"
