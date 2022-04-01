#!/usr/bin/env bash

set -euo pipefail

if [ "$(command -v yay)" ]; then
  yay -S chezmoi lsd neovim tmux asdf-vm --noconfirm
elif [ "$(command -v paru)" ]; then
  paru -S chezmoi lsd neovim tmux asdf-vm --noconfirm
fi

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
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

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
# exec: replace current process with chezmoi init
$chezmoi init --apply "--source=$script_dir"

plugins=$(awk '{print $1;}' tool-versions-actual | tr '\n' ' ')

for plugin in $plugins; do
  asdf plugin add "$plugin" 2>/dev/null || true
done

asdf install
