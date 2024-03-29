#!/usr/bin/env bash

source common.sh

IFS=' ' read -r -a packages <<<"$common_packages"
IFS=' ' read -r -a pypacks <<<"$python_packages"

aur_install() {
    local orig_dir="$PWD"
    local package=$1
    local temp_dir=$(mktemp -d)

    log_info "Installing $package from AUR"

    git clone "https://aur.archlinux.org/$package.git" "$temp_dir"
    cd "$temp_dir"

    makepkg -sicC --noconfirm

    cd "$orig_dir"
}

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

for package in "${pypacks[@]}"; do
    packages+=("python-$package")
done
unset package


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
sudo systemctl enable --now pkgfile-update.timer

log_info "Running pkgfile-update.service"
sudo systemctl start pkgfile-update.service

log_info "Configuring and enabling reflector"
paru -Sy --noconfirm --needed reflector
sudo cp ../misc/reflector.conf /etc/xdg/reflector/reflector.conf
sudo systemctl enable --now reflector
