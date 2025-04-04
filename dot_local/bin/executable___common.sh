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

# Uses "less" to show text if stdin is longer than the amount of lines on the terminal
pager() {
    if [[ $(echo "$*" | wc -l) -gt $(tput lines) ]]; then
        echo "$*" | less -R
    fi
    echo -e "$*"
}

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
exists() { command -v "$1" &>/dev/null; }

# Format a log message based on provided data
# Usage:
#   base_log "Color escape code" "Level string (max 5 chars)" "Message"
base_log() {
    local color="$1"
    local level="$2  "
    local message="$3"

    local padded_level=${level:0:5} # Cut to max width of 5

    echo -e "[$(timestamp)] $color$padded_level$NC $message"
}

# Logs to stdout/stderr with the provided level (based on name)
# Usage:
#   log_* "Some message"
log_error() { base_log "$RED" "ERR" "$*" &>/dev/stderr; }
log_warn() { base_log "$YELLOW" "WRN" "$*"; }
log_info() { base_log "$GREEN" "INF" "$*"; }
alias log=log_info

# Sends a notification to the desktop environment
# Usage:
#   notify <icon> <time> <name> <message> [urgency]
notify() {
    local icon="$1"
    local time="$2"              # Time in seconds
    local name="$3"              # Name in "header" of notification
    local message="$4"           # Main notification body
    local urgency="${5:-normal}" # low, normal, critical

    local opts=(
        --icon="$icon"
        --urgency="$urgency"
        --app-name="$name"
    )

    if [[ $urgency == "critical" ]]; then
        opts+=(--wait)

        notify-send "${opts[@]}" "$message" &
        local notification_id=$!

        sleep "$time"
        kill -INT "$notification_id"
    else
        opts+=(--expire-time="$((time * 1000))")

        notify-send "${opts[@]}" "$message"
    fi
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

# Turn X seconds into "HH:MM:SS"
# Usage:
#   human_time <seconds>
human_time() {
    local time=$1 # Seconds
    local hours=$((time / 60 / 60 % 24))
    local minutes=$((time / 60 % 60))
    local seconds=$((time % 60))

    printf '%02d:%02d:%02d' "$hours" "$minutes" "$seconds"
}
