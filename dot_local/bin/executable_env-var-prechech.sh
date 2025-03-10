#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

set -o errexit  # exit on error
set -o nounset  # do not use unset variables
set -o pipefail # fail early in piped command

readonly required_vars=("$@")

missing_any=0

for var_name in "${required_vars[@]}"; do
    if [[ -z "${!var_name}" ]]; then
        echo "Warning: Environment variable $var_name is missing."
        missing_any=1
    fi
done

# Optional: Check if any were missing and handle accordingly
if [[ "$missing_any" -eq 1 ]]; then
    echo "Some environment variables are missing."
    exit 1
else
    echo "All required environment variables are set."
fi
