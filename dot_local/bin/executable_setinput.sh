#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"


set -o errexit                  # exit on error
set -o pipefail                 # fail early in piped commands
set -o nounset                  # do not use unset variables
[[ -n "${TRACE:-}" ]] && set -x # debug

readonly dependencies=(
    pactl
    grep
    head
    awk
    tr
)

now() { date "+%Y-%m-%d %H:%M:%S"; }

get_device_id() {
    local device_name="$1"

    pactl list sources \
        | grep -e "Source #" -e "Description:" \
        | grep -iv monitor \
        | grep -iB1 "$device_name" \
        | head -n1 \
        | awk '{print $2}' \
        | tr -d '#'
}

main() {
    local device
    local device_id

    device="$1"
    check_dependencies "${dependencies[@]}"

    device_id=$(get_device_id "$device")
    log_info "Resolved device id for '$device': $device_id"

    pactl set-default-source "$device_id"
}

main "$@"
