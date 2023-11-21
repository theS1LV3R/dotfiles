#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

# shellcheck disable=SC2311,SC2312
# SC2311 - Bash implicitly disabled set -e for this function invocation because it's inside a command substitution.
# SC2312 - Consider invoking this command separately to avoid masking its return value (or use '|| true' to ignore).

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'


pager() {
    if [[ $(echo "$*" | wc -l) -gt $(tput lines) ]]; then
        echo "$*" | less -R
    fi
    echo -e "$*"
}

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
installed() { command -v "$1" &>/dev/null; }

base_log() { echo -e "$1[$(timestamp) $2]$NC $3"; }

log_error() { base_log "$RED" "ERROR" "$*" &>/dev/stderr; }
log_warn() { base_log "$YELLOW" "WARN" "$*"; }
log_info() { base_log "$GREEN" "INFO" "$*"; }
log_ask() { base_log "$BLUE" "ASK" "$*"; }
alias log=log_info

notify() {
    _icon=$1
    _time=$2
    _name=$3
    _message=$4

    notify-send \
        --icon="$_icon" \
        --urgency="critical" \
        --wait \
        --app-name="$_name" \
        "$_message" 2>/dev/null &
    notification_id=$!

    sleep "$_time"
    kill -INT "$notification_id"
}
