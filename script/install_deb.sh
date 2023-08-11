#!/usr/bin/env bash

source common.sh

export DEBIAN_FRONTEND=noninteractive

set -x

IFS=' ' read -r -a packages <<<"$common_packages"
IFS=' ' read -r -a pypacks <<<"$python_packages"

packages+=(
    python3
    python3-pip
    command-not-found
)

sudo apt update
sudo apt upgrade -y
sudo apt install aptitude

for package in "${pypacks[@]}"; do
    if ! pip3 install --user "$package" 2>/dev/null; then
        packages+=("python3-$package")
    fi
done
unset package

for package in "${packages[@]}"; do
    sudo aptitude install -y "$package" || true
done

if ! installed chezmoi; then
    bin_dir="$HOME/.local/bin"
    chezmoi="$bin_dir/chezmoi"

    log_info "Chezmoi not installed, installing to $chezmoi"

    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
else
    chezmoi=$(command -v chezmoi)
fi

$chezmoi init --apply theS1LV3R

if [[ ! -d $HOME/.asdf ]] && ! installed asdf; then
    log_info "asdf not installed, installing to $HOME/.asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
fi

log_info "Sourcing asdf"
set +euo pipefail
# shellcheck source=/dev/null
. "$HOME/.asdf/asdf.sh"
set -euo pipefail

log_info "Updating asdf"
asdf update

firefox-profile-switcher-connector-install() {
    log_info "Installing firefox-profile-switcher-connector"

    if [[ $(uname -m) != "x86_64" ]]; then
        log_warn "Not x86_64, not installing "
        return
    fi

    if ! installed firefox && ! installed firefox-developer-edition; then
        log_info "Firefox not detected, not installing"
        return
    fi

    tmpdir=$(mktemp -d)
    wget -P "$tmpdir" https://github.com/null-dev/firefox-profile-switcher-connector/releases/download/v0.1.1/linux-x64.deb
    sudo dpkg -i "$tmpdir/linux-x64.deb"
}
firefox-profile-switcher-connector-install
