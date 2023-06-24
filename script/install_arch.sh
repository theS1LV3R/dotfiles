#!/usr/bin/env bash

source common.sh

IFS=' ' read -r -a packages <<<"$common_packages"

packages+=(
    base-devel
    archlinux-keyring
    neovim
    chezmoi                            # dotfile management
    lsd                                # Better ls command
    asdf-vm                            # Version management
    firefox-profile-switcher-connector # Firefox extension allowing better profile switching
    pkgfile                            # For command-not-found
)

while IFS=' ' read -r package; do
    packages+=("python-$package")
done <<<"$python_packages"
unset package

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

log_info "Enabling pkgfile-update.timer"
sudo systemctl enable pkgfile-update.timer

log_info "Running pkgfile-update.service"
sudo systemctl start pkgfile-update.service
