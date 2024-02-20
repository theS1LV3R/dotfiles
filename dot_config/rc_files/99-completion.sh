#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=00-xdg-env.sh
source /dev/null # Effectively a noop, only here for shellcheck

command -v register-python-argcomplete >/dev/null && eval "$(register-python-argcomplete pipx)"

# pip bash completion start
_pip_completion() {
    COMPREPLY=(
        $(COMP_WORDS="${COMP_WORDS[*]}" \
            COMP_CWORD=$COMP_CWORD \
            PIP_AUTO_COMPLETE=1 \
            $1 2>/dev/null)
    )
}
complete -o default -F _pip_completion pip
# pip bash completion end

complete -C /usr/bin/mcli mcli
