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

  [[ ! -z $@ ]] && bytes="$*"

  openssl rand -hex $bytes
}

update() {
  # Check for apt systems
  if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt upgrade -y
    return
  fi

  if command -v pacman &>/dev/null; then
    if command -v paru &>/dev/null; then
      paru -Syu --noconfirm
    elif command -v yay &>/dev/null; then
      yay -Syu --noconfirm
    else
      sudo pacman -Syu
    fi

    return
  fi

  # Check for yum systems
  if command -v yum &>/dev/null; then
    sudo yum update
    return
  fi

  # Check for brew systems
  if command -v brew &>/dev/null; then
    brew update
    brew upgrade
    return
  fi
}

path() {
  # echo: Replace : with newline
  # sed =: Add line numbers after each line
  # last sed:
  #  - n N    Read/append the next line of input into the pattern space.
  #  - then replace newlines with tabs, this affects every other newline
  echo ${PATH//:/\\n} | sed '=' | sed 'N;s:\n:\t:'
}
fpath() {
  echo ${FPATH//:/\\n} | sed '=' | sed 'N;s:\n:\t:'
}

precmd() { print -Pn "\e]2;%n@%M:%~\a"; } # title bar prompt
