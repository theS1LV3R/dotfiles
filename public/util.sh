#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]>>>${NC} $1"
}

log_warn() {
  echo -e "${RED}[WARN]!!!${NC} $1"
}

log_ask() {
  echo -e "${YELLOW}[ASK] ???${NC} $1"
}

log_verbose() {
  echo -e "${BLUE}[VERB]---${NC} $1"
}
