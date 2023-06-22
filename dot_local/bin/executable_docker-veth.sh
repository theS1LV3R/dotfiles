#!/usr/bin/env bash

usage() {
    cat <<HELP_USAGE

    $0  Show the veth interface associated of containers

HELP_USAGE
}

case "$1" in
-h | --help)
    usage
    exit 0
    ;;
*) ;;
esac

veth=""

containers=$(docker ps --format '{{.ID}} {{.Names}}' "$@")

get_veth() {
    # This function expects docker container ID as the first argument
    veth=""
    networkmode=$(docker inspect -f "{{.HostConfig.NetworkMode}}" "$1")
    if [[ "$networkmode" == "host" ]]; then
        veth="host"
    else
        pid=$(docker inspect --format '{{.State.Pid}}' "$1")
        ifindex=$(sudo nsenter -t "$pid" -n ip link | sed -n -e 's/.*eth0@if\([0-9]*\):.*/\1/p')
        if [[ -z "$ifindex" ]]; then
            veth="not found"
        else
            veth=$(ip -o link | grep ^"$ifindex" | sed -n -e 's/.*\(veth[[:alnum:]]*@if[[:digit:]]*\).*/\1/p')
        fi
    fi
}

while IFS= read -r line; do
    containerid=$(echo "$line" | awk '{ print $1 }')
    get_veth "$containerid"
    echo "$veth $line"
done <<<"$containers"
