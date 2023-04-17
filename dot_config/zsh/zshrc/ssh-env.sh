#!/usr/bin/env bash

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-"/run/user/$UID"}/ssh-agent.socket"
#export SSH_ASKPASS_REQUIRE="prefer"
export SSH_ASKPASS='/usr/bin/ksshaskpass'
