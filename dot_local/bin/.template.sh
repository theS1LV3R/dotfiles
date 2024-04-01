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
    getopt
    
)

usage() {
    cat <<EOF
NAME
    $0

SYNOPSIS
    $0 [OPTION...]

DESCRIPTION
    INSERT DESCRIPTION HERE

OPTIONS
    -h,          --help                 Show this message
    -v,          --verbose              Log verbose messages to console.
EOF
}

now() { date "+%Y-%m-%d %H:%M:%S"; }

get_options() {
    local parsed

    # Define short options
    local options=hv
    # Define long options
    local longopts=help,verbose

    parsed=$(getopt --options="$options" --longoptions="$longopts" --name="$0" -- "$@")

    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
        # e.g. return value is 1
        #  then getopt has complained about wrong arguments to stdout
        exit 2
    fi

    # read getopt’s output this way to handle the quoting right:
    eval set -- "$parsed"

    while true; do
        case "$1" in
        -h | --help)
            usage
            shift
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error" >&2
            exit 3
            ;;
        esac
    done
}

main() {
    get_options "$@"
    check_dependencies "${dependencies[@]}"

    # DO STUFF HERE
}

main "$@"
