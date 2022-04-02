#!/usr/bin/env bash

set -euo pipefail

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --codespaces | -c)
    export CODESPACES=true
    shift
    ;;
  --help | -h)
    echo "Usage: install.sh [--codespaces]"
    echo "  --codespaces: In codespaces"
    exit 0
    ;;
  *)
    echo "Unknown argument: $1"
    exit 1
    ;;
  esac
done

if [[ -z "${CODESPACES:-}" ]]; then
  echo "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
  echo "Press enter to continue or ctrl-c to abort."
  read -r
fi

# Install dotfiles
echo "Installing dotfiles..."

apt_packages="libssl-dev zlib1g-dev zsh neovim unzip"
arch_packages="chezmoi lsd neovim tmux asdf-vm zsh unzip"

echo "Installing packages..."
if [ "$(command -v yay)" ]; then
  yay -S $arch_packages --noconfirm
elif [ "$(command -v paru)" ]; then
  paru -S $arch_packages --noconfirm
elif [ "$(command -v apt)" ]; then
  echo "Sudo for apt"
  sudo apt install -y $apt_packages
fi

echo "Installing chezmoi..."
if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"

  echo "Chezmoi not installed, installing to $chezmoi"

  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

$chezmoi init theS1LV3R --apply

echo "Installing asdf..."
if [[ ! -d $HOME/.asdf ]]; then
  echo "asdf not installed, installing to $HOME/.asdf"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
fi

set +euo pipefail
. $HOME/.asdf/asdf.sh
set -euo pipefail

plugins=$(awk '{print $1;}' tool-versions-actual | tr '\n' ' ')

for plugin in $plugins; do
  asdf plugin add "$plugin" 2>/dev/null || true
done

asdf install

echo "Installing zsh..."
chsh -s "/bin/zsh"

echo "Installing ptsh"
dir=$(mktemp -d)
cd $dir

git clone https://github.com/jszczerbinsky/ptSh .

make
sudo make install
