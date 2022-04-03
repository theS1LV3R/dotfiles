#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --codespaces | -c)
    export CODESPACES=true
    shift
    ;;
  --yes | -y)
    YES=true
    shift
    ;;
  *)
    echo "Unknown argument: $1"
    exit 1
    ;;
  esac
done

if [[ -z "${CODESPACES:-}" ]] && [[ -z "${YES:-}" ]]; then
  echo "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
  echo "Press enter to continue or ctrl-c to abort."
  read -r
fi

export common_packages="neovim unzip zsh tmux"

echo "Collecting information..."
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)

if [[ "${is_arch}" == "true" ]]; then
  echo "Detected Arch Linux"

  ./install_arch.sh
elif [[ "${is_debian}" == "true" ]]; then
  echo "Detected Debian"

  ./install_deb.sh
fi

./install_common.sh
