#!/usr/bin/env bash

source common.sh
IFS=$'\n\t'

IFS=' ' read -r -a packages <<<"$*"

packages+=()

sudo apt update
sudo apt install -y "${packages[@]}"

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

if installed firefox || installed firefox-developer-edition; then
    log_info "Installing firefox-profile-switcher-connector"

    tmpdir=$(mktemp -d)
    wget -P "$tmpdir" https://github.com/null-dev/firefox-profile-switcher-connector/releases/download/v0.1.1/linux-x64.deb
    sudo dpkg -i "$tmpdir/linux-x64.deb"
fi
