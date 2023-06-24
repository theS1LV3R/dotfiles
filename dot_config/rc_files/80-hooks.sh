#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck disable=SC1091,SC2154
# SC1091 - Not following: (error message here)
# SC2154 - XDG_DATA_HOME is referenced but not assigned
[[ -n "$BASH_VERSION" ]] && {
    source "$XDG_DATA_HOME/bash-preexec/bash-preexec.sh"
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
}

exitzero() {
    exit 0
}

[[ -n "$ZSH_VERSION" ]] && {
    precmd() { print -Pn "\033]2;%n@%M:%~\a"; } # title bar prompt
    add-zsh-hook zshexit exitzero
}
