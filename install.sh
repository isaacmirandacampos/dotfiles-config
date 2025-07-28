#!/bin/bash

# Install fish
brew install fish

# Install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# Install fisher plugins
fisher install jorgebucaran/fisher
fisher install jethrokuan/z
fisher install jethrokuan/fzf

# Install tmux
brew install tmux

# Install lazygit
brew install lazygit

# Install lazydocker
brew install lazydocker

# Install Btop
brew install btop

# Install zoxide
brew install zoxide

# Install kitty
brew install kitty

## Use fish as default shell
chsh -s $(which fish)

## Use dotfiles config
ln -s $HOME/.dotfiles-config/fish $HOME/.config/fish
ln -s $HOME/.dotfiles-config/tmux $HOME/.config/tmux
ln -s $HOME/.dotfiles-config/btop $HOME/.config/btop
ln -s $HOME/.dotfiles-config/kitty $HOME/.config/kitty
ln -s $HOME/.dotfiles-config/nvim $HOME/.config/nvim
ln -s $HOME/.dotfiles-config/.aerospace.toml $HOME/.aerospace.toml
ln -s $HOME/.dotfiles-config/git $HOME/.config/git

### Load fish config
source ~/.config/fish/config.fish
