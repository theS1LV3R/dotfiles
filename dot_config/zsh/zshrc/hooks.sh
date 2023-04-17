#!/usr/bin/env zsh
# shellcheck shell=bash

precmd() { print -Pn "\e]2;%n@%M:%~\a"; } # title bar prompt

exitzero() {
    exit 0
}
add-zsh-hook zshexit exitzero
