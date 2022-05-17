#!/bin/bash

DIR="${HOME}/.tmux/plugins"

mkdir -p "${DIR}" || :

if [[ ! -d "${DIR}/tpm" ]]; then
 git clone https://github.com/tmux-plugins/tpm "${DIR}"/tpm
fi
