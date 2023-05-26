#!/usr/bin/env bash
# vi: ft=sh

ssh() {
  emulate -L zsh

  TERM=xterm-256color command ssh "$@"
}

dict() {
  page=$(command dict "$@")

  if [[ $(echo "$page" | wc -l) -gt $(tput lines) ]]; then
    echo "$page" | less -R
    echo -e "$page"
  else
    echo -e "$page"
  fi
}

secret() {
  bytes="${1:-48}"

  openssl rand -rand /dev/urandom -base64 $bytes | tr --delete '\n'
}

update() {
  if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt upgrade
    sudo apt autoremove --purge
    return
  fi

  if command -v pacman &>/dev/null; then
    pm="sudo pacman"

    if command -v paru &>/dev/null; then
      pm=paru
    elif command -v yay &>/dev/null; then
      pm=yay
    fi

    $pm -Syu
    $pm -Qdtq | $pm -Rsun || true

    return
  fi
}

path() {
  # echo: Replace : with newline
  # sed =: Add line numbers after each line
  # last sed:
  #  - n N    Read/append the next line of input into the pattern space.
  #  - then replace newlines with tabs, this affects every other newline
  echo "${PATH//:/\\n}" | sed '=' | sed 'N;s|\n|\t|'
}
[[ -n "$ZSH_VERSION" ]] && fpath() {
  # shellcheck disable=SC2154 # FPATH is referenced but not assigned.
  echo "${FPATH//:/\\n}" | sed '=' | sed 'N;s|\n|\t|'
}

idl() {
  id | sed -E 's| |\n|g' | sed 's|groups=|groups:\n - |' | sed -E 's|=| = |g' | sed -E 's|,|\n - |g'
}

drmgrep() {
  docker container rm "$(docker container ls -a | grep "$1" | awk '{ print $1 }')"
}
drmfgrep() {
  docker container rm -f "$(docker container ls -a | grep "$1" | awk '{ print $1 }')"
}

dnetworks() {
  docker network ls -q --filter driver=bridge | while IFS= read -r netId; do
    inspect=$(docker network inspect "$netId")

    name=$(echo "$inspect" | jq -r '.[].Name' 2>/dev/null)
    subnet=$(echo "$inspect" | jq -r '.[].IPAM.Config[].Subnet' 2>/dev/null)

    [[ -z $name || $name == "null" ]] && name=$(echo "$inspect" | jq -r '.[].name')
    [[ -z $subnet || $subnet == "null" ]] && subnet=$(echo "$inspect" | jq -r '.[].subnets[].subnet')

    echo -e "\e[1;37;40m$name\033[0m"
    echo "$subnet"
  done
}

ipinfo() {
  export GUM_SPIN_SPINNER="minidot"
  export GUM_SPIN_SHOW_OUTPUT="true"

  ip=${1:-''}

  if [[ -z "$ip" ]]; then
    ip=$(gum spin --title="Getting own public IP..." \
      -- curl -s "https://ifconfig.me")
  fi

  if [[ -z "$IPINFO_API_TOKEN" ]]; then
    echo "Missing IPinfo API token! Remember to add it to env vars - \$IPINFO_API_TOKEN"
  fi

  gum spin --title="Getting IP information..." \
    -- curl -u $IPINFO_API_TOKEN: -s "https://ipinfo.io/$ip/json" | jq

  # /me endpoint is undocumented, got it from an email to IPinfo:
  # Hello Zoe,
  # Thanks for reaching out and getting in touch!
  # We have an undocumented endpoint that you can use to conveniently grab limited data about your quota usage information.
  # https://ipinfo.io/me?token={YOUR_TOKEN}
  # This will tell you how much requests you have left.
  # I hope that helps. Let us know if you have further questions.
  # Cheers,
  # Cornelius
  usage=$(gum spin --title="Getting IPinfo usage..." \
    -- curl -u $IPINFO_API_TOKEN: -s "https://ipinfo.io/me" | jq '.requests|.month,.limit' | paste -s -d'/')
  echo "Usage this month: $usage"

  unset GUM_SPIN_SPINNER
  unset GUM_SPIN_SHOW_OUTPUT
}

optdeps() {
  pacman -Qe | awk '{print $1}' | xargs pacman -Qi | awk '/^Name/ {name=$3} /^Optional Deps/ && !/None/ {print name ":"; sub(/^Optional Deps\s*:\s*/, "", $0); gsub(/,\s*/, "\n  ", $0); print "  " $0}'
}
