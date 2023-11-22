#!/usr/bin/env bash

source common.sh

log_info "NOTE: This _will_ overwrite existing dotfiles. Make sure you have a backup."
log_info "Press enter to continue or ctrl-c to abort."
read -r

log_info "Collecting information"
os_release=""
[[ -e /etc/arch-release ]] && os_release="arch"
[[ -e /etc/debian_version ]] && os_release="debian"

_install() {
  local filename="install_$1.sh"

  # Neovim not included - Debian uses asdf
  export common_packages="entr bridge-utils unzip zsh tmux gcc neofetch curl wget net-tools vim python"
  export python_packages="httpx h2 dnspython cryptography"

  log_info "Running ./$filename"
  "./$filename"
}

case "$os_release" in
arch) log_info "Detected Arch" && _install arch ;;
debian) log_info "Detected Debian" && _install deb ;;
*) log_error "Unsupported distribution" && exit 1 ;;
esac

log_info "Installing asdf plugins"
while IFS= read -r line; do
  [[ "$line" == "" ]] && continue
  [[ "$line" =~ "^#" ]] && continue

  plugin=$(awk '{ print $1 }' <<<"$line")
  url=$(awk '{ print $4 }' <<<"$line" || true)

  asdf plugin add "$plugin" "$url" || true
done <"$HOME/.tool-versions"

asdf install

[[ "$os_release" == "debian" ]] && {
  # These are in the AUR on arch, so we dont need to manually install them there
  log_info "Installing cargo packages"
  rust_packages=(lsd bat)
  for pkg in "${rust_packages[@]}"; do
    log_info "Installing: $pkg"
    cargo install "$pkg"
  done
}

zi_install() {
  log_info "Installing ZI"
  source ../dot_config/rc_files/11-zi-env.sh

  mkdir -p "${ZI[BIN_DIR]}"
  git clone https://github.com/z-shell/zi.git "${ZI[BIN_DIR]}"
}
zi_install

log_info "Performing misc actions"

TMUX_COPY_BACKEND="Enable tmux-copy-backend.socket"
CHANGE_SHELL="Change shell"
SUDOERSD_FILES="/etc/sudoers.d files"
PODMAN_DOCKER="Podman 'nodocker' file"

options="$(gum choose --no-limit --selected="All" "All" "$CHANGE_SHELL" "$SUDOERSD_FILES" "$PODMAN_DOCKER" "$TMUX_COPY_BACKEND")"

if [[ $options == "All" ]] || [[ $options =~ ^$CHANGE_SHELL$ ]]; then
  log_verbose "$CHANGE_SHELL"

  zsh_bin=$(command -v zsh)

  if ! grep -qv "$zsh_bin" /etc/shells; then
    log_info "$zsh_bin not found in /etc/shells - enter password to add"
    echo "$zsh_bin" | sudo tee -a /etc/shells
  fi

  sudo chsh -s "$zsh_bin" "$USER"
fi

if [[ $options == "All" ]] || [[ $options =~ ^$SUDOERSD_FILES$ ]]; then
  log_verbose "$SUDOERSD_FILES"

  sudo cp -r ../misc/sudoers.d/* /etc/sudoers.d/
fi

if [[ $options == "All" ]] || [[ $options =~ ^$PODMAN_DOCKER$ ]]; then
  log_verbose "$PODMAN_DOCKER"

  mkdir -p "$HOME/.local/share/containers"
  touch "$HOME/.local/share/containers/nodocker"
fi

if [[ $options == "All" ]] || [[ $options =~ ^$TMUX_COPY_BACKEND$ ]]; then
  log_verbose "$TMUX_COPY_BACKEND"

  systemctl --user daemon-reload
  systemctl --user enable --now tmux-copy-backend.socket
fi

log_info 'Done :)'
