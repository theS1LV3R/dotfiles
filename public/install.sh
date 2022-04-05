#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

_REPO="https://github.com/theS1LV3R/dotfiles.git"
export SUB=false
export YES=false
export CODESPACES=false

echo ">>> Collecting information..."
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)
export common_packages="neovim unzip zsh tmux gcc neofetch curl net-tools vim"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --codespaces | -c)
    export CODESPACES=true
    shift
    ;;
  --yes | -y)
    export YES=true
    shift
    ;;
  --sub | -s)
    export SUB=true
    shift
    ;;
  *)
    echo "!!! Unknown argument: $1"
    exit 1
    ;;
  esac
done

if [[ "$CODESPACES" == "false" ]] &&
  [[ "$YES" == "false" ]] &&
  [[ "${SUB}" == "false" ]]; then
  echo ">>> NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
  echo ">>> Press enter to continue or ctrl-c to abort."
  read -r </dev/tty
fi

if [[ ! $(command -v git) ]]; then
  echo ">>> Installing git..."
  if [[ $is_debian = "true" ]]; then
    sudo apt install git
  elif [[ $is_arch = "true" ]]; then
    sudo pacman -S git
  else
    echo "!!! Unsupported OS"
    exit 1
  fi
fi

is_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null && echo true || echo false)

echo $#
echo "$@"

if [[ "$is_git_repo" == "false" ]] && [[ "$SUB" == "false" ]]; then
  echo ">>> Not in git repo, cloning to temp dir"
  TEMP_DIR=$(mktemp -d)

  git clone --depth 1 $_REPO "$TEMP_DIR"

  cd "$TEMP_DIR"/public

  bash "./install.sh" -s "$@"
fi

_install() {
  filename="install_$1.sh"

  shift

  echo ">>> Running ./$filename"
  # shellcheck disable=SC1090
  . "./$filename" "$@"
}

if [[ "${is_arch}" == "true" ]]; then
  echo ">>> Detected Arch Linux"
  _install arch "$common_packages"
elif [[ "${is_debian}" == "true" ]]; then
  echo ">>> Detected Debian"
  _install deb "$common_packages"
else
  echo "!!! Unsupported distribution"
  exit 1
fi

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

read -r -p ">>> Install all or ask manually? [A/m] " response </dev/tty
if [[ ! $response =~ ^([mM])$ ]] || [[ $YES == "true" ]]; then
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
