function _fzf_cd_hidden -d "fzf: cd em um diretório (incluindo ocultos)"
    set -l dir (fd --type d --hidden --follow --exclude .git 2>/dev/null \
        | fzf --query (commandline -t) --prompt 'cd> ')
    if test -n "$dir"
        cd $dir
        commandline -f repaint
    end
end
