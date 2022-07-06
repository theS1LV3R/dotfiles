#!/usr/bin/env bash

set -euo pipefail

readonly url="https://github.com/zigtools/zls/releases/latest/download/x86_64-linux.tar.xz"
readonly save_archive="/tmp/zls-latest.tar.xz"
readonly bin_output="${HOME}/.local/bin"

wget "${url}" -O "${save_archive}"

tar -xJ --strip-components=1 -C "${bin_output}" -f "${save_archive}" bin/zls

chmod +x "${bin_output}/zls"
