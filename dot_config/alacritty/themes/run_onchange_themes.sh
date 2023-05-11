#!/usr/bin/env bash

TMPDIR=$(mktemp -d)
REPO="https://github.com/alacritty/alacritty-theme"

mkdir -p "$XDG_CONFIG_HOME/alacritty/themes"
git clone --depth 1 "$REPO" "$TMPDIR"

cp -v "$TMPDIR/themes/"* "$XDG_CONFIG_HOME/alacritty/themes"
