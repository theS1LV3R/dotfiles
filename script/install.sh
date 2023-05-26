#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

_REPO="https://github.com/theS1LV3R/dotfiles.git"

if ! command -v git &>/dev/null; then
  echo "Missing git. Install git and try again"
  exit 1
fi

is_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null && echo true)

if [[ -z "$is_git_repo" ]]; then
  log_info "Not in git repo, cloning to temp dir"
  TEMP_DIR=$(mktemp -d)

  git clone --depth 1 "$_REPO" "$TEMP_DIR"

  cd "$TEMP_DIR"/script

  exec bash "./install.sh" "$@"
fi

source common.sh

log_info "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
log_info "Press enter to continue or ctrl-c to abort."
read -r </dev/tty

log_info "Collecting information..."
os_release=""
[[ -e /etc/arch-release ]] && os_release="arch"
[[ -e /etc/debian_version ]] && os_release="debian"

_install() {
  filename="install_$1.sh"

  # Neovim not included - Debian uses asdf
  common_packages="unzip zsh tmux gcc neofetch curl wget net-tools vim"

  log_info "Running ./$filename"
  # shellcheck disable=SC1090
  source "$filename" "$common_packages"
}

case "$os_release" in
arch) log_info "Detected Arch" && _install arch ;;
debian) log_info "Detected Debian" && _install deb ;;
*) log_error "Unsupported distribution" && exit 1 ;;
esac

while IFS= read -r line; do
  [[ "$line" == "" ]] && continue
  [[ "$line" =~ "^#" ]] && continue

  plugin=$(awk '{ print $1 }' <<<"$line")
  url=$(awk '{ print $4 }' <<<"$line" || true)

  asdf plugin add "$plugin" "$url" || true
done <"$HOME/.tool-versions"

asdf install

[[ "$os_release" == "debian" ]] && {
  cargo install lsd
  cargo install bat
}

CHANGE_SHELL="Change shell"
SUDOERSD_FILES="/etc/sudoers.d files"
PODMAN_DOCKER="Podman 'nodocker' file"

options="$(gum choose --no-limit --selected="All" "All" "$CHANGE_SHELL" "$SUDOERSD_FILES" "$PODMAN_DOCKER")"

if [[ $options =~ ^All$ ]] || [[ $options =~ ^$CHANGE_SHELL$ ]]; then
  log_verbose "$CHANGE_SHELL"

  zsh_bin=$(command -v zsh)

  if ! grep -qv "$zsh_bin" /etc/shells; then
    log_info "$zsh_bin not found in /etc/shells - enter password to add"
    echo "$zsh_bin" | sudo -- tee -a /etc/shells
  fi

  sudo chsh -s "$zsh_bin" "$USER"
fi

if [[ $options =~ ^All$ ]] || [[ $options =~ ^$CHANGE_SHELL$ ]]; then
  log_verbose "$SUDOERSD_FILES"

  prompt="[sudo] enter password to copy files:"
  sudo -p "$prompt" -- cp -r ../misc/sudoers.d/* /etc/sudoers.d/
fi

if [[ $options =~ ^All$ ]] || [[ $options =~ ^$PODMAN_DOCKER$ ]]; then
  log_verbose "$PODMAN_DOCKER"

  mkdir -p "$HOME/.local/share/containers"
  touch "$HOME/.local/share/containers/nodocker"
fi

log_info 'Done :)'
