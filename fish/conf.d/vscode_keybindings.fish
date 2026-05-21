function _vscode_keybindings --on-event fish_prompt
    functions -e (status current-function)

    bind \cw backward-kill-word
    if bind -M insert >/dev/null 2>&1
        bind -M insert \cw backward-kill-word
    end
end
