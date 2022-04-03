#!/usr/bin/env bash

set -euo pipefail

# From install.sh
declare common_packages

packages="$common_packages libssl-dev zlib1g-dev"

sudo apt update
sudo apt install -y $packages


if [ ! "$(command -v chezmoi)" ]; then
    bin_dir="$HOME/.local/bin"
    chezmoi="$bin_dir/chezmoi"

    echo "Chezmoi not installed, installing to $chezmoi"

    if [ "$(command -v curl)" ]; then
        sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
    elif [ "$(command -v wget)" ]; then
        sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
    else
        echo "To install chezmoi, you must have curl or wget installed." >&2
        exit 1
    fi
else
    chezmoi=$(which chezmoi)
fi

$chezmoi init theS1LV3R --apply

echo "Installing asdf..."
if [[ ! -d $HOME/.asdf ]] && [[ ! $(command -v asdf) ]]; then
    echo "asdf not installed, installing to $HOME/.asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
fi

set +euo pipefail
# shellcheck source=/dev/null
. "$HOME/.asdf/asdf.sh"
set -euo pipefail
