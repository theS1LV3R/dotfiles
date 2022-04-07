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

packages+=(
    libssl-dev
    zlib1g-dev
    make
    make-doc
    libcurl4-openssl-dev
    libncurses6
    libncurses-dev
)

sudo apt update
sudo apt install -y "${packages[@]}"

if [ ! "$(command -v chezmoi)" ]; then
    bin_dir="$HOME/.local/bin"
    chezmoi="$bin_dir/chezmoi"

    log_info "Chezmoi not installed, installing to $chezmoi"

    if [ "$(command -v curl)" ]; then
        sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
    elif [ "$(command -v wget)" ]; then
        sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
    else
        log_warn "To install chezmoi, you must have curl or wget installed." >&2
        exit 1
    fi
else
    chezmoi=$(which chezmoi)
fi

$chezmoi init theS1LV3R --apply --force

if [[ ! -d $HOME/.asdf ]] && [[ ! $(command -v asdf) ]]; then
    log_info "asdf not installed, installing to $HOME/.asdf"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0
fi

set +euo pipefail
# shellcheck source=/dev/null
. "$HOME/.asdf/asdf.sh"
set -euo pipefail
