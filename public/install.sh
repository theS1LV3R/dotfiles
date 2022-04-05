#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

source ./util.sh

_REPO="https://github.com/theS1LV3R/dotfiles.git"
export SUB=false
export YES=false
export CODESPACES=false

log_info "Collecting information..."
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
    log_warn "Unknown argument: $1"
    exit 1
    ;;
  esac
done

if [[ "$CODESPACES" == "false" ]] &&
  [[ "$YES" == "false" ]] &&
  [[ "${SUB}" == "false" ]]; then
  log_info "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
  log_info "Press enter to continue or ctrl-c to abort."
  read -r </dev/tty
fi

if [[ ! $(command -v git) ]]; then
  log_info "Installing git..."
  if [[ $is_debian = "true" ]]; then
    sudo apt install git
  elif [[ $is_arch = "true" ]]; then
    sudo pacman -Sy git
  else
    log_warn "Unsupported OS"
    exit 1
  fi
fi

is_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null && echo true || echo false)

if [[ "$is_git_repo" == "false" ]] && [[ "$SUB" == "false" ]]; then
  log_info "Not in git repo, cloning to temp dir"
  TEMP_DIR=$(mktemp -d)

  git clone --depth 1 $_REPO "$TEMP_DIR"

  cd "$TEMP_DIR"/public

  bash "./install.sh" -s "$@"
fi

_install() {
  filename="install_$1.sh"

  shift

  log_info "Running ./$filename"
  # shellcheck disable=SC1090
  . "./$filename" "$@"
}

if [[ "${is_arch}" == "true" ]]; then
  log_info "Detected Arch Linux"
  _install arch "$common_packages"
elif [[ "${is_debian}" == "true" ]]; then
  log_info "Detected Debian"
  _install deb "$common_packages"
else
  log_warn "Unsupported distribution"
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
    log_verbose "Changing shell to zsh"

    command -v zsh | sudo tee -a /etc/shells
    user=$USER
    sudo chsh -s "$(which zsh)" "$user"
  fi
}

install_ptsh() {
  orig_dir=$PWD

  dir=$(mktemp -d)
  cd "$dir"

  log_verbose "Cloning ptSh"
  git clone https://github.com/jszczerbinsky/ptSh .

  log_verbose "Making and installing ptSh"
  make
  sudo make install

  cd "$orig_dir"
}

install_tty-clock() {
  orig_dir=$PWD

  dir=$(mktemp -d)

  log_verbose "Cloning tty-clock and patches"
  git clone https://github.com/xorg62/tty-clock "$dir"
  cp -r ../misc/patches/tty-clock "$dir"/patches

  cd "$dir"

  log_verbose "Applying patches"
  patch -p1 <patches/*.patch

  log_verbose "Making and installing tty-clock"
  make
  PREFIX=~/.local make install
}

pwfeedback() {
  log_verbose "Installing pwfeedback"
  sudo cp ../misc/01-pwfeedback /etc/sudoers.d/
}

log_ask "Install all or ask manually?"
read -r -p "[A/m] " response </dev/tty
if [[ ! $response =~ ^([mM])$ ]] || [[ $YES == "true" ]]; then
  change_shell
  install_ptsh
  pwfeedback
  install_tty-clock
else

  log_info "Installing manually"

  log_ask "Set zsh as default shell?"
  read -r -p "[y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    change_shell
  fi

  log_ask "Install ptSh?"
  read -r -p "[y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    install_ptsh
  fi

  log_ask "Configure sudo pwfeedback?"
  read -r -p "[y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    pwfeedback
  fi

  log_ask "Install tty-clock?"
  read -r -p "[y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    install_tty-clock
  fi

fi
