#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

declare -A ZI

ZI[HOME_DIR]="$HOME/.local/share/zi"
ZI[BIN_DIR]="${ZI[HOME_DIR]}/bin"
export ZSH_CACHE_DIR="${ZI[HOME_DIR]}"
