#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

source common.sh

IFS=' ' read -r -a packages <<<"$*"

packages+=(
    base-devel
    archlinux-keyring
    neovim
    chezmoi                            # dotfile management
    lsd                                # Better ls command
    asdf-vm                            # Version management
    firefox-profile-switcher-connector # Firefox extension allowing better profile switching
)

aur_install() {
    orig_dir="$PWD"
    package=$1

    log_info "Installing $package from AUR"

    dir=$(mktemp -d)
    git clone "https://aur.archlinux.org/$package.git" "$dir"
    cd "$dir"

    makepkg -sicC --noconfirm

    cd "$orig_dir"
}

log_info "Installing paru"
aur_install paru

log_ask "Install yay?"
read -r -p "[y/N]" install_yay </dev/tty
if [[ "$install_yay" =~ ^[Yy] ]]; then
    aur_install yay
fi

paru -Sy --noconfirm --needed "${packages[@]}"

log_info "Initializing chezmoi"
chezmoi init --apply theS1LV3R
