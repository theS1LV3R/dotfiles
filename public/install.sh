#!/usr/bin/env bash
pwd
set -x
set -euo pipefail
IFS=$'\n\t'

_REPO="https://github.com/theS1LV3R/dotfiles.git"
export SUB=false
export YES=false
export CODESPACES=false

echo ">>> Collecting information..."
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)
export common_packages="neovim unzip zsh tmux gcc"

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
  exit
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

_install common
