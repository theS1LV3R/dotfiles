#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

plugins=$(awk '{print $1;}' "$HOME/.tool-versions" | tr '\n' ' ')

IFS=' ' read -r -a plugins <<<"$plugins"

for plugin in "${plugins[@]}"; do
  asdf plugin add "$plugin" 2>/dev/null || true
done

asdf install

change_shell() {
  if [ "$(command -v zsh)" ]; then
    echo "Changing shell to zsh"

    command -v zsh | sudo tee -a /etc/shells
    user=$USER
    sudo chsh -s "$(which zsh)" "$user"
  fi
}

install_ptsh() {
  orig_dir=$PWD

  dir=$(mktemp -d)
  cd "$dir"

  git clone https://github.com/jszczerbinsky/ptSh .

  make
  sudo make install
  cd "$orig_dir"
}

install_tty-clock() {
  orig_dir=$PWD

  dir=$(mktemp -d)

  git clone https://github.com/xorg62/tty-clock "$dir"
  cp -r ../misc/patches/tty-clock "$dir"/patches

  cd "$dir"

  patch -p1 <patches/*.patch

  make

  PREFIX=~/.local make install
}

pwfeedback() {
  sudo cp ../misc/01-pwfeedback /etc/sudoers.d/
}

# if YES=true, then assume yes to all prompts
read -r -p ">>> Install all or ask manually? [A/m] " response </dev/tty
if [[ ! $response =~ ^([mM])$ ]]; then
  change_shell
  install_ptsh
  pwfeedback
  install_tty-clock
else

  read -r -p "Set zsh as default shell? [y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    change_shell
  fi

  read -r -p "Install ptsh? [y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    install_ptsh
  fi

  read -r -p "Install pwfeedback to sudo? [y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    pwfeedback
  fi

  read -r -p "Install tty-clock? [y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    install_tty-clock
  fi

fi
