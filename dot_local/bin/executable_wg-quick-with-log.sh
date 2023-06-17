#!/usr/bin/env bash

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

readonly NOTIFICATION_TIME="${NOTIFICATION_TIME:-3}"

action=$1
interface=$2

echo "$(timestamp) - $action - $interface - pre-pkexec - $(tty)" >>"$XDG_DATA_HOME/wg-quick-log.txt"

set +e
pkexec_output=$(pkexec wg-quick "$action" "$interface" 2>&1)
pkexec_exitcode=$?
set -e

if [[ $pkexec_exitcode -gt 0 ]]; then
    if [[ $(tty) != "not a tty" ]]; then
        echo "$pkexec_output"
    else
        notify network-vpn "$NOTIFICATION_TIME" Wireguard "Failed changing wireguard connection: \
$pkexec_output"
    fi
    exit "$pkexec_exitcode"
fi

echo "$(timestamp) - $action - $interface" >>"$XDG_DATA_HOME/wg-quick-log.txt"

if [[ $NOTIFICATION_TIME -gt 0 ]]; then
    if [[ $(tty) != "not a tty" ]]; then
        echo "$pkexec_output"
    else
        notify network-vpn "$NOTIFICATION_TIME" Wireguard "Set wireguard connection $interface $action" &
    fi
fi
