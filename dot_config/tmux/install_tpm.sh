#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=../../dot_local/bin/executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly repo="https://github.com/tmux-plugins/tpm"
readonly target="$HOME/.local/share/tmux/plugins/tpm/"

echo "Installing tpm..."
git clone "$repo" "$target"

echo "Installing tpm plugins..."
bash "$target/bin/install_plugins"
