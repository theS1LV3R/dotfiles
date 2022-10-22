#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

_REPO="https://github.com/theS1LV3R/dotfiles.git"

if ! command -v git &>/dev/null; then
  echo "Missing git. Install git and try again"
  exit 1
fi

is_git_repo=$(git rev-parse --is-inside-work-tree 2>/dev/null && echo true || echo false)

if [[ "${is_git_repo}" == "false" ]]; then
  log_info "Not in git repo, cloning to temp dir"
  TEMP_DIR=$(mktemp -d)

  git clone --depth 1 "${_REPO}" "${TEMP_DIR}"

  cd "${TEMP_DIR}"/script

  exec bash "./install.sh" "$@"
fi

source common.sh

log_info "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
log_info "Press enter to continue or ctrl-c to abort."
read -r </dev/tty

log_info "Collecting information..."
is_arch=$(test -f /etc/arch-release && echo true || echo false)
is_debian=$(test -f /etc/debian_version && echo true || echo false)

_install() {
  filename="install_$1.sh"

  shift

  log_info "Running ./$filename"
  # shellcheck disable=SC1090
  source "$filename" "$@"
}

common_packages="unzip zsh tmux gcc neofetch curl net-tools vim"
# Neovim not included - Debian uses asdf

if [[ "${is_arch}" == "true" ]]; then
  log_info "Detected Arch"
  _install arch "$common_packages"
elif [[ "${is_debian}" == "true" ]]; then
  log_info "Detected Debian"
  _install deb "$common_packages"
else
  log_warn "Unsupported distribution"
  exit 1
fi

awk '{print $1;}' "${HOME}/.tool-versions" | while IFS= read -r plugin; do
  asdf plugin add "$plugin" 2>/dev/null || true
done

asdf install

if [[ "${is_debian}" == "true" ]]; then
  cargo install lsd
  cargo install bat
fi

change_shell() {
  zsh_bin=$(command -v zsh)

  if [[ -n $zsh_bin ]]; then
    log_verbose "Changing shell to zsh"

    if grep -qv "${zsh_bin}" /etc/shells; then
      echo "${zsh_bin}" sudo tee -a /etc/shells
    fi

    sudo chsh -s "${zsh_bin}" "${USER}"
  else
    log_warn "zsh not found, skipping"
  fi
}

sudoersd-files() {
  log_verbose "Installing sudoers.d files"

  log_ask "Copying files to /etc/sudoers.d requires root privileges. Do you want to continue?"
  read -r -p "[y/N] " response </dev/tty
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    sudo cp -r ../misc/sudoers.d/* /etc/sudoers.d/
  fi
}

log_ask "All or manual?"
read -r -p "[A/m] " response </dev/tty
if [[ ! $response =~ ^([mM])$ ]]; then
  change_shell
  sudoersd-files
else

  log_info "Installing manually"

  log_ask "Set zsh as default shell?"
  read -r -p "[y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    change_shell
  fi

  log_ask "Copy sudoers.d files?"
  read -r -p "[y/N] " response </dev/tty
  if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudoersd-files
  fi
fi

log_info 'Done :)'
