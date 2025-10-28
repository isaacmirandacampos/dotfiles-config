#!/bin/bash

# Instalation script (macOS)

## Install fish
brew install fish

## Install fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

## Install fisher plugins
fisher install jorgebucaran/fisher
fisher install jethrokuan/z
fisher install jethrokuan/fzf

## Install tmux
brew install tmux

## Install lazygit
brew install lazygit

## Install lazydocker
brew install lazydocker

## Install Btop
brew install btop

## Install zoxide
brew install zoxide

## Install kitty
brew install kitty

## Install yazi
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font ouch rich-cli

## Use fish as default shell
chsh -s $(which fish)

## Use dotfiles config
ln -sf $HOME/dotfiles-config/fish $HOME/.config/fish
ln -sf $HOME/dotfiles-config/tmux $HOME/.config/tmux
ln -sf $HOME/dotfiles-config/btop $HOME/.config/btop
ln -sf $HOME/dotfiles-config/kitty $HOME/.config/kitty
ln -sf $HOME/dotfiles-config/nvim $HOME/.config/nvim
ln -sf $HOME/dotfiles-config/aerospace $HOME/.config/aerospace
ln -sf $HOME/dotfiles-config/git $HOME/.config/git
ln -sf $HOME/dotfiles-config/.markdownlint.yaml $HOME/.config/.markdownlint.yaml
ln -sf $HOME/dotfiles-config/aerospace/.aerospace.toml /Applications/AeroSpace.app/Contents/Resources/default-config.toml
ln -sf $HOME/dotfiles-config/starship.toml $HOME/.config/starship.toml
ln -sf $HOME/dotfiles-config/dictionaries $HOME/.config/dictionaries
ln -sf $HOME/dotfiles-config/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $HOME/dotfiles-config/yazi $HOME/.config/yazi
ln -sf $HOME/dotfiles-config/yabai $HOME/.config/yabai
ln -sf $HOME/dotfiles-config/aerospace/.aerospace.toml $HOME/
ln -sf $HOME/dotfiles-config/sketchybar $HOME/sketchybar

### Load fish config
source ~/.config/fish/config.fish
