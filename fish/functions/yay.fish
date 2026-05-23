function yay --wraps yay --description 'yay com Python do sistema (necessário pra builds AUR)'
    set -lx PATH /usr/bin /usr/local/bin $PATH
    command yay $argv
end
