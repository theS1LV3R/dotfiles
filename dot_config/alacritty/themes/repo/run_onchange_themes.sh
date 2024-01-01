#!/usr/bin/env bash

readonly XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly repo="https://github.com/alacritty/alacritty-theme"
readonly out_dir="$XDG_CONFIG_HOME/alacritty/themes/repo"

tmpdir=$(mktemp -d)

git clone --depth 1 "$repo" "$tmpdir"

mkdir -vp "$out_dir"
cp -v "$tmpdir/themes/"* "$out_dir"
rm -rfv "$tmpdir"
