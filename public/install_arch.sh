#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

source ./util.sh

IFS=' ' read -r -a packages <<<"$*"

aur_install() {
    package=$1

    log_info "Installing $package from AUR"

    dir=$(mktemp -d)
    cd "$dir"

    git clone "https://aur.archlinux.org/$package.git"
    cd paru
    makepkg -si --noconfirm
}

packages+=(
    chezmoi
    lsd
    asdf-vm
    zlib
    base-devel
    archlinux-keyring
)

if [ "$(command -v yay)" ] && [ "$(command -v paru)" ]; then
    pm="yay"

    log_ask "Found yay and paru, select which one to use"
    read -r -p "[Y/p] " yay_or_paru </dev/tty
    if [[ "${yay_or_paru}" =~ ^[Pp] ]]; then
        pm="paru"
    fi

    log_info "Using $pm"
    $pm -Sy --noconfirm --needed "${packages[@]}"
else
    log_ask "Neither yay nor paru not found, select one to install"
    read -r -p "[Y/p]" yay_or_paru </dev/tty
    if [[ "${yay_or_paru}" =~ ^[Pp] ]]; then
        orig_dir=$(pwd)

        aur_install paru

        cd "$orig_dir"
    else
        orig_dir=$(pwd)

        aur_install yay

        cd "$orig_dir"
    fi
fi

log_info "Initializing chezmoi"
chezmoi init --apply theS1LV3R
