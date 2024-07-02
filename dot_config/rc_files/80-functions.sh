#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=00-xdg-env.sh
source /dev/null # Effectively a noop, only here for shellcheck

ssh() {
    emulate -L zsh

    TERM=xterm-256color command ssh "$@"
}

dict() {
    local page=$(command dict "$@")

    if [[ $(echo "$page" | wc -l) -gt $(tput lines) ]]; then
        echo "$page" | less -R
        echo -e "$page"
    else
        echo -e "$page"
    fi
}

secret() {
    local bytes="${1:-48}"

    openssl rand -rand /dev/urandom -base64 "$bytes" | tr --delete '\n'
}

update() {
    if command -v apt &>/dev/null; then
        sudo apt update
        sudo apt upgrade
        sudo apt autoremove --purge
        return
    fi

    if command -v pacman &>/dev/null; then
        local package_manager="sudo pacman"

        if command -v paru &>/dev/null; then
            package_manager=paru
        elif command -v yay &>/dev/null; then
            package_manager=yay
        fi

        $package_manager -Syu
        $package_manager -Qdtq | $package_manager -Rsun || true

        return
    fi
}

path() {
    # echo: Replace : with newline
    # sed =: Add line numbers after each line
    # last sed:
    #  - N = Read/append the next line of input into the pattern space.
    #  - ; = Next command
    #  - s|\n|\t| = Replace newlines with tabs, this affects every other newline, since the next
    #               line was already added into the pattern space, and this is not a global replace.
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
    local inspect
    local name
    local subnet

    docker network ls -q --filter driver=bridge | while IFS= read -r netId; do
        inspect=$(docker network inspect "$netId")

        name=$(echo "$inspect" | jq -r '.[].Name' 2>/dev/null)
        subnet=$(echo "$inspect" | jq -r '.[].IPAM.Config[].Subnet' 2>/dev/null)

        [[ -z $name || $name == "null" ]] && name=$(echo "$inspect" | jq -r '.[].name')
        [[ -z $subnet || $subnet == "null" ]] && subnet=$(echo "$inspect" | jq -r '.[].subnets[].subnet')

        echo -e "\
\033[1;37;40m$name\033[0m
$subnet
"
    done
}

ipinfo() {
    export GUM_SPIN_SPINNER="minidot"
    export GUM_SPIN_SHOW_OUTPUT="true"

    local ip=${1:-''}
    local ip6=''

    local usage

    if [[ -z "$ip" ]]; then
        ip=$(gum spin --title="Getting own public IP (v4)..." \
            -- curl -4s "https://ifconfig.co")
        ip6=$(gum spin --title="Getting own public IP (v6)..." \
            -- curl -6s "https://ifconfig.co")
    fi

    if [[ -z "$IPINFO_API_TOKEN" ]]; then
        echo "Missing IPinfo API token! Remember to add it to env vars - \$IPINFO_API_TOKEN"
    fi

    gum spin --title="Getting IP information..." \
        -- curl -su "$IPINFO_API_TOKEN:" "https://ipinfo.io/$ip/json" | jq

    if [[ "$ip6" != "" ]]; then
        gum spin --title="Getting IP information (v6)..." \
            -- curl -su "$IPINFO_API_TOKEN:" "https://ipinfo.io/$ip6/json" | jq
    fi

    # `/me` endpoint is undocumented, got it from an email to IPinfo:
    # Hello Zoe,
    # Thanks for reaching out and getting in touch!
    # We have an undocumented endpoint that you can use to conveniently grab limited data about your quota usage information.
    # https://ipinfo.io/me?token={YOUR_TOKEN}
    # This will tell you how much requests you have left.
    # I hope that helps. Let us know if you have further questions.
    # Cheers,
    # Cornelius
    usage=$(gum spin --title="Getting IPinfo usage..." \
        -- curl -su "$IPINFO_API_TOKEN:" "https://ipinfo.io/me" | jq '.requests|.month,.limit' | paste -s -d'/')
    echo "Usage this month: $usage"

    unset GUM_SPIN_SPINNER
    unset GUM_SPIN_SHOW_OUTPUT
}

optdeps() {
    pacman -Qe | awk '{print $1}' | xargs pacman -Qi | awk '/^Name/ {name=$3} /^Optional Deps/ && !/None/ {print name ":"; sub(/^Optional Deps\s*:\s*/, "", $0); gsub(/,\s*/, "\n  ", $0); print "  " $0}'
}

urldecode() {
    : "${*//+/ }"
    echo -e "${_//%/\\x}"
}

gentestfiles() {
    local filesizes=(
        5
        10
        15
        25
        50
        100
        150
        200
    )

    for size in "${filesizes[@]}"; do
        dd if=/dev/zero of="${size}MB" bs=1000 count="$(( size * 1000 ))"
    done
}

s_client() {
    local host="$1"
    local port="${2:-443}"

    openssl s_client -showcerts -servername "$host" -connect "$host:$port" </dev/null \
        | openssl x509 -text -noout
}
