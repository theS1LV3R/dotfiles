#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4
# shellcheck shell=bash disable=SC2139
# SC2139 - This expands when defined, not when used. Consider escaping.

# shellcheck source=00-xdg-env.sh
source /dev/null # Effectively a noop, only here for shellcheck

checkexists() {
    command -v "$1" &>/dev/null
}

enhanced_aliases=(
    "vim nvim"
    "ls lsd"
    "ipcalc sipcalc"
    "jq yq"
    "cat bat"
)

for alias in "${enhanced_aliases[@]}"; do
    orig=$(cut -d' ' -f1 <<<"$alias")
    new=$(cut -d' ' -f2 <<<"$alias")

    checkexists "$new" || continue
    alias "b$orig"="$(command -v "$orig")"
    alias "$orig"="$new"
done
unset enhanced_aliases
unset alias
unset orig
unset new
unset checkexists

alias pcat='bat --pager=none --plain'

# ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -F'
alias lah='ls -lah'

colorauto_commands=(
    lsd
    dir
    vdir
    grep
    fgrep
    egrep
    diff
    ip
)

for command in "${colorauto_commands[@]}"; do
    alias "$command"="$command --color=auto"
done
unset colorauto_commands
unset command

# Systemctl aliases
systemctl_aliases=(
    start
    restart
    stop
    status
    enable
    disable
    reload
)
for alias in "${systemctl_aliases[@]}"; do
    alias "$alias"="sudo systemctl $alias"
done
unset systemctl_aliases
unset alias

alias c="clear -x" # Do not clear scrollback
alias define="dict"
alias hostname="hostnamectl hostname"
alias open='xdg-open'
alias history="history 0" # force zsh to show the complete history
alias dotfiles="code $(chezmoi source-path)"
alias ipl="ip -brief a"
alias tb='nc termbin.com 9999'
alias depcycle='comm -23 <(pacman -Qqd | sort -u) <(pacman -Qqe | xargs -n1 pactree -u | sort -u) | comm -23 - <(pacman -Qqttd | sort -u)' # https://www.reddit.com/r/archlinux/comments/ohv6g9/does_pacman_not_resolve_cycles_in_dependency/

dps_base='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.RunningFor}}\t{{.State}}\t{{.Status}}"'
dps_sort='(sed -u 1q ; sort -k2)'

alias dps="$dps_base | $dps_sort"
alias dpsa="$dps_base -a | $dps_sort"
alias dcupdate="dcpull && dcdn ; dcupd ; dclf --since=1m"

alias wgup="sudo wg-quick up "
alias wgdown="sudo wg-quick down "

alias deactivateLinux="systemctl --user start activate-linux.service"
alias activateLinux="systemctl --user stop activate-linux.service"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
