#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=00-xdg-env.sh
source /dev/null # Effectively a noop, only here for shellcheck

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
    rust_dir=$(asdf where rust 2>/dev/null)
    if [[ -n "$rust_dir" ]] && [[ "$rust_dir" != "System version is selected" ]]; then
        # shellcheck source=/dev/null
        source "$rust_dir/env"
        export CARGO_HOME="$rust_dir"
    fi
fi
