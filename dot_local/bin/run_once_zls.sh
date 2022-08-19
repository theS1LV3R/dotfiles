#!/usr/bin/env bash

set -euo pipefail

readonly url="https://github.com/zigtools/zls/"
readonly bin_dir="${HOME}/.local/bin"
readonly git_dir="/tmp/zigtools-zls"

if [[ -d "${git_dir}" ]]; then
  rm -rf "${git_dir}"
fi

git clone --depth 1 --recurse-submodules "${url}" "${git_dir}"

cd "${git_dir}"

if zig build -Drelease-safe; then

  cp "zig-out/bin/zls" "${bin_dir}"

  chmod +x "${bin_dir}/zls"

  zls config
fi
