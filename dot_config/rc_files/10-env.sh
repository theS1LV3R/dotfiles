#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

ASDF=false

if [[ -f /opt/asdf-vm/asdf.sh ]]; then
    source /opt/asdf-vm/asdf.sh
    ASDF=true
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
    # shellcheck source=/dev/null
    source "$HOME/.asdf/asdf.sh"
    ASDF=true
fi

if [[ "$ASDF" == true ]]; then
    rust_dir=$(asdf where rust)
    if [[ -n "$rust_dir" ]]; then
        # shellcheck source=/dev/null
        source "$rust_dir/env"
        export CARGO_HOME="$rust_dir"
    fi
fi
