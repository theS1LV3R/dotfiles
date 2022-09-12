#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

source common.sh

IFS=' ' read -r -a packages <<<"$*"

packages+=(
    chezmoi
    lsd
    asdf-vm
    zlib
    base-devel
    archlinux-keyring
    pkgfile
    python-virtualenv # For COQ - nvim
)

aur_install() {
    package=$1

    log_info "Installing $package from AUR"

    dir=$(mktemp -d)
    cd "$dir"

    git clone "https://aur.archlinux.org/$package.git"
    cd paru
    makepkg -si --noconfirm
}

pm=null

_yay=$(command -v yay)
_paru=$(command -v paru)

if [[ -n $_yay ]] && [[ -n $_paru ]]; then
    log_ask "Found yay and paru, select which one to use"
    read -r -p "[Y/p] " yay_or_paru </dev/tty
    if [[ "${yay_or_paru}" =~ ^[Pp] ]]; then
        pm="paru"
    else
        pm="yay"
    fi

    log_info "Using $pm"
elif [[ -n $_yay ]] && [[ -z $_paru ]]; then
    log_info "Found yay, but not paru, using yay"
    pm="yay"
elif [[ -z $_yay ]] && [[ -n $_paru ]]; then
    log_info "Found paru, but not yay, using paru"
    pm="paru"
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

$pm -Sy --noconfirm --needed "${packages[@]}"

log_info "Initializing chezmoi"
chezmoi init --apply theS1LV3R
