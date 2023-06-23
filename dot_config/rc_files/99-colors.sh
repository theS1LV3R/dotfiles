#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

# enable color support of ls, less and man
if [[ -x /usr/bin/dircolors ]]; then
    if [[ -r ~/.dircolors ]]; then
        eval "$(dircolors -b ~/.dircolors)";
    else
        eval "$(dircolors -b)";
    fi

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    if [[ -n "$ZSH_VERSION" ]]; then
        # shellcheck disable=SC2296 # Parameter expansions can't start with (. Double check syntax.
        zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
        # shellcheck disable=all
        export ZLS_COLORS="$LS_COLORS"
    fi
fi
