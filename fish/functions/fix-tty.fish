function fix-tty -d "Restaura o terminal após um processo crashar com stdin em raw mode"
    stty sane
    printf '\033c'        # RIS — full reset (limpa tela, atributos, modo)
    tput cnorm 2>/dev/null # cursor visível
    commandline -f repaint
end
