#!/usr/bin/env bash

_shell=$(ps -o fname --no-headers $$)

# shellcheck disable=SC1090,SC2154
# 1090 = Non-constant source
# 2154 = Undefined variable (TERM_PROGRAM)
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path "$_shell")"

unset _shell
