#!/usr/bin/env bash

set -euo pipefail

echo "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
echo "Press enter to continue or ctrl-c to abort."
read -r

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

# Install dotfiles
echo "Installing dotfiles..."

# Create symlinks
for file in $(find . -maxdepth 1 -name '.*' -not -name '.*.swp' -not -name 'install.sh' -not -name 'README.md' -not -name 'LICENSE'); do
  if [[ -f "$HOME/$file" ]]; then
    echo "WARNING: File already exists: $HOME/$file"
    echo "Press enter to overwrite or ctrl-c to abort."
    read -r
  fi
  ln -sf "$PWD/$file" "$HOME/$file"
done

# Install codespaces
if $codespaces; then
  echo "Installing codespaces..."
  curl -sL https://codespaces.io/install.sh | bash
fi

echo "Done."

apt_packages="libssl-dev zlib1g-dev zsh"
arch_packages="chezmoi lsd neovim tmux asdf-vm zsh"

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
plugins=$(awk '{print $1;}' tool-versions-actual | tr '\n' ' ')

for plugin in $plugins; do
  asdf plugin add "$plugin" 2>/dev/null || true
done

asdf install

echo "Installing zsh..."
chsh -s "/bin/zsh"

echo "Installing ptsh"
ptsh_version=0.3.2-beta
ptsh_url= <<EOF
https://github.com/jszczerbinsky/ptSh/releases/download/v${ptsh_version}/\
ptSh_v${ptsh_version}_linux_x86_64.zip
EOF

# Download to /tmp using wget, extract to .local
wget -qO- "$ptsh_url" | tar -xz -C /tmp
