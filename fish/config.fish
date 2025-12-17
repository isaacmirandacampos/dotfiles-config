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

# Homebrew
set -gx PATH /opt/homebrew/bin $PATH
eval (/opt/homebrew/bin/brew shellenv)

alias venv="python3 -m venv .venv && source .venv/bin/activate"
alias lg='lazygit'
alias ld='lazydocker'
alias t='tmux-sessionizer'
alias spf='spf -c $HOME/.config/superfile/config.toml'
alias s='yazi'

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none
  --color=bg+:#002c38 \
  --color=bg:#001419 \
  --color=border:#063540 \
  --color=fg:#9eabac \
  --color=gutter:#001419 \
  --color=header:#c94c16 \
  --color=hl+:#c94c16 \
  --color=hl:#c94c16 \
  --color=info:#637981 \
  --color=marker:#c94c16 \
  --color=pointer:#c94c16 \
  --color=prompt:#c94c16 \
  --color=query:#9eabac:regular \
  --color=scrollbar:#063540 \
  --color=separator:#063540 \
  --color=spinner:#c94c16 \
"

set -gx EDITOR nvim

set -gx PATH /opt/homebrew/opt/curl/bin $PATH
set -gx LDFLAGS -L/opt/homebrew/opt/curl/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/curl/include

set -gx PKG_CONFIG_PATH /opt/homebrew/opt/curl/lib/pkgconfig

set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin /usr/local/bin /usr/bin /bin /usr/sbin /sbin $PATH

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0

## Zoxigen

zoxide init fish --cmd cd | source
set -x _ZO_DATA_DIR ~/.local/share/zoxide/

# Enable fzf key bindings
source (brew --prefix)/opt/fzf/shell/key-bindings.fish

## Cargo | Rust
source "$HOME/.cargo/env.fish"

# tmux-sessionizer
set PATH "$PATH":"$HOME/.config/tmux/"

bind \cf tmux-sessionizer
# tmux-sessionizer end

# pnpm
set -gx PNPM_HOME /Users/isaacdmcampos/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# write
set --export PATH /Users/isaacdmcampos/.local/bin $PATH

# starship
# export STARSHIP_CONFIG=~/.config/fish/starship.toml
# starship init fish | source
# starship end

# opencode
fish_add_path /Users/isaacdmcampos/.opencode/bin
