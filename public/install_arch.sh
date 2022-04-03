#!/usr/bin/env bash

set -euo pipefail

# From install.sh
declare common_packages

packages="$common_packages chezmoi lsd asdf-vm zlib"

if [ "$(command -v yay)" ] && [ "$(command -v paru)" ]; then
    read -r -p "Found yay and paru, select which one to use: [Y/p] " yay_or_paru
    if [[ "${yay_or_paru}" =~ ^[Pp] ]]; then
        echo "Using paru"
        paru -Sy --noconfirm --needed $packages
    else
        echo "Using yay"
        yay -Sy --noconfirm --needed $packages
    fi
else
    read -r -p "Yay or paru not found, select one to install: [Y/p]" yay_or_paru
    if [[ "${yay_or_paru}" =~ ^[Pp] ]]; then
        echo "Installing paru"
        orig_dir=$(pwd)

        dir=$(mktemp -d)
        cd "$dir"

        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si --noconfirm

        cd "$orig_dir"
    else
        echo "Installing yay"
        orig_dir=$(pwd)

        dir=$(mktemp -d)
        cd "$dir"

        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm

        cd "$orig_dir"
    fi
fi

chezmoi init --apply theS1LV3R
