#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

# shellcheck disable=SC2311,SC2312
# SC2311 - Bash implicitly disabled set -e for this function invocation because it's inside a command substitution.
# SC2312 - Consider invoking this command separately to avoid masking its return value (or use '|| true' to ignore).

set -euo pipefail

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
exists() { command -v "$1" &>/dev/null; }

base_log() { echo -e "$1[$(timestamp) $2]$NC $3"; }

log_error() { base_log "$RED" "ERROR" "$*" &>/dev/stderr; }
log_warn() { base_log "$YELLOW" "WARN" "$*"; }
log_info() { base_log "$GREEN" "INFO" "$*"; }
log_ask() { base_log "$BLUE" "ASK" "$*"; }
alias log=log_info

notify() {
    local icon="$1"
    local time="$2"
    local name="$3"
    local message="$4"

    local opts=(
        --icon="$icon"
        --urgency="critical"
        --wait
        --app-name="$name"
    )

    timeout "$time" notify-send "${opts[@]}" "$message" 2>/dev/null
}

# Reads dependencies in the format of executable:description
# Usage:
#   check_dependencies "exec1:Description one" "exec2:Description 2" ...
# Exit codes:
#   0: No missing dependencies
#   1: Missing dependencies
check_dependencies() {
    local _dependencies=("$@")
    local _missing_dependencies=()

    for _dependency in "${_dependencies[@]}"; do
        local _executable="${_dependency%:*}"

        if ! exists "$_executable"; then
            _missing_dependencies+=("$_dependency")
        fi
    done

    if [[ "${#_missing_dependencies[@]}" -eq 0 ]]; then
        return 0
    fi

    if [[ "${#_missing_dependencies[@]}" -gt 0 ]]; then
        log_info "Missing required dependencies:"
        for _dependency in "${_missing_dependencies[@]}"; do
            local _executable="${_dependency%:*}"
            local _description="${_dependency#*:}"

            [[ -z "$_description" ]] && _description="no description provided"

            log_info "  - $_executable : $_description"
        done
    fi

    unset _dependency

    return 1
}
