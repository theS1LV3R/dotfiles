#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

set -o errexit                  # exit on error
set -o nounset                  # do not use unset variables
set -o pipefail                 # fail early in piped commands
[[ -n "${TRACE:-}" ]] && set -x # debug

#############
# Constants #
#############

readonly EXIT_OK=0
readonly EXIT_GENERAL_ERR=1
readonly EXIT_GETOPT_ERR=2
readonly EXIT_OPTIONS_ERROR=3

# Dependencies in the format of "executable:"
readonly DEPENDENCIES=(
    getopt
    
)

#############
# Variables #
#############

#? general variables

#####################
# Utility functions #
#####################

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
        exit "$EXIT_GETOPT_ERR"
    fi

    # read getopt’s output this way to handle the quoting right:
    eval set -- "$parsed"

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
        -h | --help)
            usage
            shift
            exit "$EXIT_OK"
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error" >&2
            exit "$EXIT_OPTIONS_ERROR"
            ;;
        esac
        shift
    done
}

##################
# Main functions #
##################

main() {
    check_dependencies "${DEPENDENCIES[@]}"
    get_options "$@"

    # DO STUFF HERE
}

main "$@"
