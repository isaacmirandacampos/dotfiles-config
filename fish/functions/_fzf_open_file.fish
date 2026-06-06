function _fzf_open_file -d "fzf: escolhe um arquivo e abre com xdg-open"
    set -l file (fd --type f --hidden --follow --exclude .git 2>/dev/null \
        | fzf --query (commandline -t) --prompt 'open> ')
    if test -n "$file"
        xdg-open $file >/dev/null 2>&1 &
        disown
    end
    commandline -f repaint
end
