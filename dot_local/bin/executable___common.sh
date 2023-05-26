#!/usr/bin/env bash
# shellcheck disable=SC2311,SC2312
# vi: ft=sh:ts=2:sw=2

# SC2311 - Bash implicitly disabled set -e for this function invocation because it's inside a command substitution.
# SC2312 - Consider invoking this command separately to avoid masking its return value (or use '|| true' to ignore).

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

pager() {
  if [[ $(echo "$@" | wc -l) -gt $(tput lines) ]]; then
    echo "$@" | less -R
  fi
  echo -e "$@"
}

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
installed() { command -v "$1" &>/dev/null; }

log_error() { echo -e "${RED}[$(timestamp) ERROR]${NC} $1" &>/dev/stderr; }
log_warn() { echo -e "${YELLOW}[$(timestamp) WARN]${NC} $1"; }
log_info() { echo -e "${GREEN}[$(timestamp) INFO]${NC} $1"; }
log_ask() { echo -e "${BLUE}[$(timestamp) ASK]${NC} $1"; }
