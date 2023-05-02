#!/usr/bin/env bash
# shellcheck shell=bash
ASDF=false

if [[ -f /opt/asdf-vm/asdf.sh ]]; then
  . /opt/asdf-vm/asdf.sh
  ASDF=true
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.asdf/asdf.sh"
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

# shellcheck disable=SC2154 # ZSH_SCRIPTS not defined
[[ -e "$ZSH_SCRIPTS/env.local.sh" ]] && source "$ZSH_SCRIPTS/env.local.sh"
