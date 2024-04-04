function fish_greeting
    # do nothing
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

if type -q exa
    alias ls "exa --icons $1"
    alias ll "exa -l -g --icons"
    alias lla "ll -a"
end
rvm default
alias z zellij
alias rent "cd ~/projects/rentbrella/"
alias dow "cd ~/Downloads"
alias pers "cd ~/projects/personal"

alias u="uuidgen | xclip -selection clipboard"
alias venv="python3 -m venv .venv && source .venv/bin/activate.fish"
alias z="zellij"
alias lg='lazygit'
