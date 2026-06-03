set fish_greeting ""

# theme
# set -g theme_color_scheme terminal-dark
# set -g fish_prompt_pwd_dir_length 1
# set -g theme_display_user yes
# set -g theme_hide_hostname no
# set -g theme_hostname always
# solarized-osaka Color Palette
set -l foreground 839395
set -l selection 1a6397
set -l base01 576d74
set -l red db302d
set -l orange c94c16
set -l yellow b28500
set -l green 849900
set -l purple 6d71c4
set -l cyan 29a298
set -l pink d23681

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $base01
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $base01

# Completion Pager Colors
set -g fish_pager_color_progress $base01
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $base01
set -g fish_pager_color_selected_background --background=$selection

# Starship
set -g fish_cursor_default block

# Homebrew (macOS only)
if test (uname) = Darwin
    set -gx PATH /opt/homebrew/bin $PATH
    eval (/opt/homebrew/bin/brew shellenv)
end

alias venv="python3 -m venv .venv && source .venv/bin/activate"
alias lg='lazygit'
alias ld='lazydocker'
alias t='tmux-sessionizer'
alias spf='spf -c $HOME/.config/superfile/config.toml'
alias s='yazi'

# Posting collection (grouplink-api)
abbr --add pgl 'posting --collection "/home/isaacdmcampos/workspaces/gl/alexandria/tools/POSTING - Api Tools" --env "/home/isaacdmcampos/workspaces/gl/alexandria/tools/POSTING - Api Tools/.env.local"'

# fzf: opções montadas como LISTA e unidas com espaço (string join) para garantir
# UMA linha só — sem newlines embutidos (que quebram o eval do plugin fzf.fish em
# __fzf_open/__fzf_cd/etc) e SEM referenciar a própria variável (evita o acúmulo
# que acontecia ao re-sourcing/shells aninhados, já que ela é exportada).
set -gx FZF_DEFAULT_OPTS (string join ' ' -- \
  --height=40% \
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
  --color=spinner:#e06c75)

set -gx EDITOR nvim

if test (uname) = Darwin
    set -gx PATH /opt/homebrew/opt/curl/bin $PATH
    set -gx LDFLAGS -L/opt/homebrew/opt/curl/lib
    set -gx CPPFLAGS -I/opt/homebrew/opt/curl/include
    set -gx PKG_CONFIG_PATH /opt/homebrew/opt/curl/lib/pkgconfig
    set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH
end

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# Go (GOPATH for compiled binaries)
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0

## Zoxigen

zoxide init fish --cmd cd | source
set -x _ZO_DATA_DIR ~/.local/share/zoxide/

# Enable fzf key bindings
if test (uname) = Darwin
    source (brew --prefix)/opt/fzf/shell/key-bindings.fish
else if test -f /usr/share/fzf/key-bindings.fish
    source /usr/share/fzf/key-bindings.fish
end

# tmux-sessionizer
set PATH "$PATH":"$HOME/.config/tmux/"

bind \cf tmux-sessionizer
# tmux-sessionizer end

# write
set --export PATH $HOME/.local/bin $PATH

# Python 
set -gx MISE_DISABLE_TOOLS python

# starship
# export STARSHIP_CONFIG=~/.config/fish/starship.toml
# starship init fish | source
# starship end

# opencode
fish_add_path "$HOME/.opencode/bin"

# libpq (macOS only — on Arch it's in /usr/bin)
if test (uname) = Darwin
    fish_add_path /opt/homebrew/opt/libpq/bin
end

mise activate fish | source
