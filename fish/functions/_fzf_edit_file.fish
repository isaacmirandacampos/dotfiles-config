function _fzf_edit_file -d "fzf: escolhe um arquivo e abre no \$EDITOR"
    set -l file (fd --type f --hidden --follow --exclude .git 2>/dev/null \
        | fzf --query (commandline -t) --prompt 'edit> ')
    if test -n "$file"
        commandline -r -- "$EDITOR "(string escape -- $file)
        commandline -f execute
    end
    commandline -f repaint
end
