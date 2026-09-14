#!/usr/bin/env bash
# Bootstrap a new machine by symlinking these dotfiles into place
# and installing Homebrew packages from .Brewfile.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$DOTFILES_DIR/$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Skipping $dest (already exists and is not a symlink)"
    return
  fi

  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

link ".gitconfig" "$HOME/.gitconfig"
link ".tmux.conf" "$HOME/.tmux.conf"
link ".zshrc" "$HOME/.zshrc"
link ".Brewfile" "$HOME/.Brewfile"
link "nvim" "$HOME/.config/nvim"
link "ghostty/config" "$HOME/.config/ghostty/config"
link "pretty.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/pretty.zsh-theme"

if command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew packages..."
  brew bundle --file="$HOME/.Brewfile"
else
  echo "Homebrew not found; skipping 'brew bundle'. Install it from https://brew.sh first."
fi

echo "Done. Restart your shell (or run 'exec zsh') to pick up the changes."
