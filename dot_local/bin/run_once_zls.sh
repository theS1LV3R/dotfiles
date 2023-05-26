#!/usr/bin/env bash
# vi: ft=sh:ts=2:sw=2

exit

set -euo pipefail

readonly url="https://github.com/zigtools/zls/"
readonly bin_dir="$HOME/.local/bin"
readonly git_dir="/tmp/zigtools-zls"

if [[ -d "$git_dir/.git" ]]; then
  cd "$git_dir"
  git reset --hard
  git pull --recurse-submodules
else
  git clone --recurse-submodules "$url" "$git_dir"
fi

cd "$git_dir"

zig build -Doptimize=ReleaseSafe

cp "zig-out/bin/zls" "$bin_dir"
chmod +x "$bin_dir/zls"
