#!/usr/bin/env bash


source common.sh
IFS=$'\n\t'

IFS=' ' read -r -a packages <<<"$*"

packages+=()

sudo apt update
sudo apt install -y "${packages[@]}"

if ! command_exists chezmoi; then
    bin_dir="$HOME/.local/bin"
    chezmoi="$bin_dir/chezmoi"

    log_info "Chezmoi not installed, installing to $chezmoi"

    sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
else
    chezmoi=$(command -v chezmoi)
fi

$chezmoi init --apply theS1LV3R

if [[ ! -d $HOME/.asdf ]] && ! command -v asdf >/dev/null; then
    log_info "asdf not installed, installing to $HOME/.asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
fi

set +euo pipefail
# shellcheck source=/dev/null
. "$HOME/.asdf/asdf.sh"
set -euo pipefail

tmpdir=$(mktemp -d)
origdir=$PWD
cd "$tmpdir"
wget https://github.com/null-dev/firefox-profile-switcher-connector/releases/download/v0.1.1/linux-x64.deb
sudo dpkg -i linux-x64.deb
cd "$origdir"
