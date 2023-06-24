#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
#export SSH_ASKPASS_REQUIRE="prefer"
export SSH_ASKPASS='/usr/bin/ksshaskpass'
