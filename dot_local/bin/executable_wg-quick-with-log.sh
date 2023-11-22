#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
readonly logfile="$XDG_DATA_HOME/wg-quick-log.txt"
readonly NOTIFICATION_TIME="${NOTIFICATION_TIME:-3}"
readonly action=$1
readonly interface=$2

readonly help_message="\
Usage: docker-veth.sh [OPTIONS]

Show virtual network interfaces associated with containers.

Options:
    --help    Display this help message and exit.

Example:
    $ docker-veth.sh
    Interface   Container ID    Container name
    eth0@if123  d7005eab838a    postgres_db
    eth1@if456  abcdef012345    container_name

    $ docker-veth.sh --help
    Display this help message and exit.
"

log() {
    local message=${1:-<no message>}
    echo "$(timestamp) - $action - $interface - $(tty) - $message" >>"$logfile"
}

usage() { echo "$help_message"; }

case "${1:-}" in
-h | --help)
    usage
    exit 0
    ;;
*) ;;
esac

log "pre-pkexec"

set +e
pkexec_output=$(pkexec wg-quick "$action" "$interface" 2>&1)
pkexec_exitcode=$?
set -e

if [[ $pkexec_exitcode -gt 0 ]]; then
    if [[ $(tty) != "not a tty" ]]; then
        echo "$pkexec_output"
    else
        notify network-vpn "$NOTIFICATION_TIME" Wireguard "Failed changing wireguard connection: $pkexec_output"
    fi
    exit "$pkexec_exitcode"
fi

log "post-pkexec"

if [[ $NOTIFICATION_TIME -gt 0 ]]; then
    if [[ $(tty) != "not a tty" ]]; then
        echo "$pkexec_output"
    else
        notify network-vpn "$NOTIFICATION_TIME" Wireguard "Set wireguard connection $interface $action" &
    fi
fi
