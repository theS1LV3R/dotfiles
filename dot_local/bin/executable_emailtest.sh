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

NOW=$(date)
readonly NOW

#############
# Variables #
#############

source="me@s1lv3r.codes"
destination="me@s1lv3r.codes"
subject="Test email"

mailserver=""
port=25
helo_host="${HOST:-HOSTNAME}"

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
    local options=hvs:d:f:m:p:o:
    # Define long options
    local longopts=(
        help
        verbose
        source:
        destination:
        subject:
        mailserver:
        port:
        helo-host:
    )
    parsed="$(getopt --options="$options" --longoptions="$(IFS=","; echo "${longopts[*]}")" --name="$0" -- "$@")"

    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
        # e.g. return value is 1
        #  then getopt has complained about wrong arguments to stdout
        exit "$EXIT_GETOPT_ERR"
    fi

    # read getopt’s output this way to handle the quoting right:
    eval set -- "$parsed"

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
        -s | --source)
            source="$2"
            shift
            ;;
        -d | --destination)
            destination="$2"
            shift
            ;;
        -f | --subject)
            subject="$2"
            shift
            ;;
        -m | --mailserver)
            mailserver="$2"
            shift
            ;;
        -p | --port)
            port="$2"
            shift
            ;;
        -o | --helo-host)
            helo_host="$2"
            shift
            ;;
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

    local netcat_opener=$(cat <<EOF
HELO $helo_host
MAIL FROM: $source
RCPT TO: $destination
DATA
EOF
    )
    
    local netcat_closer=$(cat <<EOF
.
QUIT
EOF
    )

    local headers=$(cat <<EOF
From: $source
To: $destination
Subject: $subject
Date: $NOW
EOF
    )

    local body=$(cat <<EOF
This is a test email sent $NOW from $USER@${HOST:-HOSTNAME}.

Destination
===========
Mailserver: $mailserver
Port: $port

Headers
=======
$headers

Netcat commands
===============
$netcat_opener
<THIS EMAIL>
$netcat_closer
EOF
    )
}

main "$@"
