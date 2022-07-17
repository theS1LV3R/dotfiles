#!/usr/bin/env bash
#! DO NOT FORMAT THIS FILE!

(( $+commands[nvim] )) && alias vim='nvim'
(( $+commands[bat] )) && alias cat='bat'
(( $+commands[ls] )) && alias ls='lsd'
(( $+commands[bat] )) && alias pcat='bat --paging=never -p' && alias bcat='/bin/cat'

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

# Termbin
alias tb='nc termbin.com 9999'

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
  alias $alias="sudo systemctl $alias"
done

# (( $+commands[ptpwd] )) && alias pwd='ptpwd'
# (( $+commands[ptcp] )) && alias cp='ptcp'

if (( $+commands[paru])) && (( !$+commands[yay] )); then
  alias yay=paru
elif (( !$+commands[paru] )) && (( $+commands[yay] )); then
  alias paru=yay
fi

# Splits a jwt string, and returns the header and payload
alias jwt="jq -R 'split(\".\") | select(length > 0) | .[0],.[1] | @base64d | fromjson'"
alias c="clear -x"
alias define=dict
alias clock="tty-clock -sScbn"
alias serial="sudo minicom"
alias hostname="hostnamectl hostname"
alias open='xdg-open'
alias history="history 0" # force zsh to show the complete history
alias dotfiles="code $DOTFILES_DIR"
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.RunningFor}}\t{{.State}}\t{{.Status}}"'
# https://www.reddit.com/r/archlinux/comments/ohv6g9/does_pacman_not_resolve_cycles_in_dependency/
alias depcycle='comm -23 <(pacman -Qqd | sort -u) <(pacman -Qqe | xargs -n1 pactree -u | sort -u) | comm -23 - <(pacman -Qqttd | sort -u)'

alias wgup="sudo wg-quick up"
alias wgdown="sudo wg-quick down"

alias deactivateLinux="systemctl --user start activate-linux.service"
alias activateLinux="systemctl --user stop activate-linux.service"
