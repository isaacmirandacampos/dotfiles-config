#!/bin/bash

# Instalation script (Arch Linux)

set -e

if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found. Install it first: https://github.com/Jguer/yay"
  exit 1
fi

# link_dir SOURCE TARGET
# If TARGET exists and isn't already a symlink to SOURCE, back it up before symlinking.
link_dir() {
  local src="$1" dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return 0
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local bak="$dest.bak.$(date +%s)"
    echo "Backing up $dest -> $bak"
    mv "$dest" "$bak"
  fi
  ln -s "$src" "$dest"
}

## Install all packages first
sudo pacman -S --needed --noconfirm \
  fish tmux lazygit btop zoxide mise sheldon starship kitty ghostty helix \
  yazi ffmpeg 7zip jq poppler fd ripgrep fzf resvg imagemagick \
  ttf-nerd-fonts-symbols ouch nodejs npm

## Helix language servers / formatters (matches helix/languages.toml)
sudo pacman -S --needed --noconfirm \
  typescript-language-server pyright ruff gopls lua-language-server \
  marksman yaml-language-server taplo-cli buf dockerfile-language-server \
  biome tailwindcss-language-server prettier

yay -S --needed --noconfirm lazydocker rich-cli sqls-bin vscode-langservers-extracted

## npm-only LSPs (no Arch package)
sudo npm install -g @prisma/language-server

## Symlink configs (before fisher, so fisher writes into the dotfiles dir)
link_dir "$HOME/dotfiles-config/fish"         "$HOME/.config/fish"
link_dir "$HOME/dotfiles-config/tmux"         "$HOME/.config/tmux"
link_dir "$HOME/dotfiles-config/btop"         "$HOME/.config/btop"
link_dir "$HOME/dotfiles-config/kitty"        "$HOME/.config/kitty"
link_dir "$HOME/dotfiles-config/nvim"         "$HOME/.config/nvim"
link_dir "$HOME/dotfiles-config/git"          "$HOME/.config/git"
link_dir "$HOME/dotfiles-config/dictionaries" "$HOME/.config/dictionaries"
link_dir "$HOME/dotfiles-config/mise"         "$HOME/.config/mise"
link_dir "$HOME/dotfiles-config/yazi"         "$HOME/.config/yazi"

mkdir -p "$HOME/.config/ghostty" "$HOME/.config/sheldon" "$HOME/.config/helix"
ln -sf "$HOME/dotfiles-config/ghostty/config"     "$HOME/.config/ghostty/config"
ln -sf "$HOME/dotfiles-config/ghostty/themes"     "$HOME/.config/ghostty/themes"
ln -sf "$HOME/dotfiles-config/zsh/plugins.toml"   "$HOME/.config/sheldon/plugins.toml"
ln -sf "$HOME/dotfiles-config/helix/config.toml"  "$HOME/.config/helix/config.toml"
ln -sf "$HOME/dotfiles-config/helix/languages.toml" "$HOME/.config/helix/languages.toml"
ln -sf "$HOME/dotfiles-config/helix/themes"       "$HOME/.config/helix/themes"

ln -sf "$HOME/dotfiles-config/.markdownlint.yaml" "$HOME/.config/.markdownlint.yaml"
ln -sf "$HOME/dotfiles-config/starship.toml"      "$HOME/.config/starship.toml"
ln -sf "$HOME/dotfiles-config/tmux/tmux.conf"     "$HOME/.tmux.conf"
ln -sf "$HOME/dotfiles-config/zsh/.zshrc"         "$HOME/.zshrc"

## Install fisher + plugins (now that fish dir is symlinked to dotfiles)
fish -c "if not functions -q fisher; curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source; end; fisher install jorgebucaran/fisher"
fish -c "fisher install jethrokuan/z"
fish -c "fisher install jethrokuan/fzf"

## Use fish as default shell (only if not already)
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v fish)" ]; then
  chsh -s "$(command -v fish)"
fi

## Arch ships helix as `helix`; provide an `hx` shim so muscle memory & scripts still work
mkdir -p "$HOME/.local/bin"
ln -sf /usr/bin/helix "$HOME/.local/bin/hx"

## Install desktop entries for the wrapped terminal apps (notes / db / yazi)
bash "$HOME/dotfiles-config/install-apps-linux.sh"
