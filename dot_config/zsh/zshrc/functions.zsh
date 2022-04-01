#!/bin/zsh

function ssh() {
    emulate -L zsh

    TERM=xterm-256color command ssh "$@"
}

wttr() {
    curl "https://wttr.in/$1?0FmM&lang=en"
}

cheat() {
    curl "https://cheat.sh/$1"
}

fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

secret() {
    bytes="64"

    if [ $# -ne 0 ]; then bytes="$*"; fi

    openssl rand -hex $bytes
}
