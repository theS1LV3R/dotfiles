#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

_REPO="https://github.com/theS1LV3R/dotfiles.git"

is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)
export common_packages="neovim unzip zsh tmux"

# If neither --codespaces nor --yes is set, ask the user for confirmation
if [[ -z "${CODESPACES:-}" ]] && [[ -z "${YES:-}" ]] && [[ -z "${SUB:-}" ]]; then
  echo "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
  echo "Press enter to continue or ctrl-c to abort."
  read -r
fi

if [[ $is_debian = "true" ]]; then
  sudo apt install git
elif [[ $is_arch = "true" ]]; then
  sudo pacman -S git
else
  echo "Unsupported OS"
  exit 1
fi

is_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null && echo true || echo false)

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
    echo "Unknown argument: $1"
    exit 1
    ;;
  esac
done

if [[ "$is_git_repo" != "true" ]]; then
  echo "Not in git repo, cloning to temp dir"
  TEMP_DIR=$(mktemp -d)

  cd "$TEMP_DIR"

  git clone --depth 1 $_REPO repo

  cd repo/public

  ./install -s "$@"
  exit
fi

echo "Collecting information..."

_install() {
  filename="install_$1.sh"

  if test -f "./$filename"; then
    echo "Running ./$filename"
    # shellcheck disable=SC1090
    . "./$filename"
  else
    echo "No ./$filename found, downloading..."
    wget https://raw.githubusercontent.com/theS1LV3R/dotfiles/master/public/$filename
    chmod +x "./$filename"
    # shellcheck disable=SC1090
    . "./$filename"
  fi
}

if [[ "${is_arch}" == "true" ]]; then
  echo "Detected Arch Linux"
  _install arch
elif [[ "${is_debian}" == "true" ]]; then
  echo "Detected Debian"
  _install deb
else
  echo "Unsupported distribution"
  exit 1
fi

_install common
