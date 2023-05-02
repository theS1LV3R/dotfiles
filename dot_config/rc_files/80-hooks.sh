#!/usr/bin/env bash
# shellcheck shell=bash

# shellcheck disable=SC1091,SC2154
# SC1091 - Not following: (error message here)
# SC2154 - XDG_DATA_HOME is referenced but not assigned
[[ -n "$BASH_VERSION" ]] && source "$XDG_DATA_HOME/bash-preexec/bash-preexec.sh"

precmd() { print -Pn "\e]2;%n@%M:%~\a"; } # title bar prompt

exitzero() {
    exit 0
}

[[ -n "$ZSH_VERSION" ]] && {
    add-zsh-hook zshexit exitzero
}
