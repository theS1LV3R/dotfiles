#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

readonly RED='\033[0;31m'
readonly YELLOW='\033[0;33m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

timestamp() { date +'%Y-%m-%d %H:%M:%S'; }
installed() { command -v "$1" &>/dev/null; }

log_error() { echo -e "${RED}[$(timestamp) ERROR]${NC} $1" &>/dev/stderr; }
log_warn() { echo -e "${YELLOW}[$(timestamp) WARN]${NC} $1"; }
log_info() { echo -e "${GREEN}[$(timestamp) INFO]${NC} $1"; }
log_ask() { echo -e "${BLUE}[$(timestamp) ASK]${NC} $1"; }
