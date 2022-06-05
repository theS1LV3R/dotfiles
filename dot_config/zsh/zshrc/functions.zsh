#!/bin/zsh

ssh() {
  emulate -L zsh

  TERM=xterm-256color command ssh "$@"
}

dict() {
  page=$(command dict "$@")

  if test $(echo "$page" | wc -l) -gt $(tput lines); then
    echo "$page" | less -R
    echo "$page"
  else
    echo -e "$page"
  fi
}

secret() {
  bytes="64"

  if [ ! -z $@ ]; then bytes="$*"; fi

  openssl rand -hex $bytes
}

update() {
  # Check for apt systems
  if [ "$(command -v apt)" ]; then
    sudo apt update
    sudo apt upgrade -y
  fi

  # Check for pacman systems
  if [ "$(command -v pacman)" ]; then
    sudo pacman -Syu
  fi

  # Check for yay or paru systems
  if [ "$(command -v yay)" ]; then
    yay -Syu --noconfirm
  elif [ "$(command -v paru)" ]; then
    paru -Syu --noconfirm
  fi

  # Check for yum systems
  if [ "$(command -v yum)" ]; then
    sudo yum update
  fi

  # Check for brew systems
  if [ "$(command -v brew)" ]; then
    brew update
    brew upgrade
  fi
}

path() {
  echo ${PATH//:/\\n} | sed '=' | sed 'N;s/\n/\t/'
}
fpath() {
  echo ${FPATH//:/\\n} | sed '=' | sed 'N;s/\n/\t/'
}

precmd() { print -Pn "\e]2;%n@%M:%~\a"; } # title bar prompt
