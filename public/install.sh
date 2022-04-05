#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

IS_GIT_REPO=$(git rev-parse --is-inside-work-tree 2>/dev/null)

if [[ "$IS_GIT_REPO" != "true" ]]; then
  echo "Not in git repo, cloning to temp dir"
  TEMP_DIR=$(mktemp -d)

  cd "$TEMP_DIR"

  git clone --depth 1 repo

  cd repo/public

  exec "$0" "$@"
fi

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
  *)
    echo "Unknown argument: $1"
    exit 1
    ;;
  esac
done

# If neither --codespaces nor --yes is set, ask the user for confirmation
if [[ -z "${CODESPACES:-}" ]] && [[ -z "${YES:-}" ]]; then
  echo "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
  echo "Press enter to continue or ctrl-c to abort."
  read -r
fi

export common_packages="neovim unzip zsh tmux"

echo "Collecting information..."
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)

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
