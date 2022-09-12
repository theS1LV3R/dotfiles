#!/usr/bin/env bash
# shellcheck disable=SC2311,SC2312
# vi: ft=bash:ts=2:sw=2

set -euo pipefail
IFS=$'\n\t'

export RED='\033[0;31m'
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color

pager() {
  if [[ $(echo "$1" | wc -l) -gt $(tput lines) ]]; then
    echo "$@" | less -R
  fi
  echo -e "$1"
}

timestamp() {
  date --rfc-3339=seconds
}

log_info() {
  echo -e "${GREEN}[$(timestamp) INFO]${NC}\t $1"
}

log_warn() {
  echo -e "${YELLOW}[$(timestamp) WARN]${NC}\t $1"
}

log_ask() {
  echo -e "${BLUE}[$(timestamp) ASK]${NC}\t $1"
}

log_error() {
  echo -e "${BLUE}[$(timestamp) ERROR]${NC}\t $1"
}
