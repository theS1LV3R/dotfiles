#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]>>>${NC} $1"
}

log_warn() {
    echo -e "${RED}[WARN]!!!${NC} $1"
}

log_ask() {
    echo -e "${YELLOW}[ASK] ???${NC} $1"
}

log_verbose() {
    echo -e "${BLUE}[VERB]---${NC} $1"
}

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
