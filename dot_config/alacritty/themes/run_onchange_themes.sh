#!/usr/bin/env bash

readonly XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
readonly repo="https://github.com/alacritty/alacritty-theme"

tmpdir=$(mktemp -d)

mkdir -p "$XDG_CONFIG_HOME/alacritty/themes"

git clone --depth 1 "$repo" "$tmpdir"

cp -v "$tmpdir/themes/"* "$XDG_CONFIG_HOME/alacritty/themes"
