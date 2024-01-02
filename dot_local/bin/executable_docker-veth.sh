#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly requirements=(
    docker
    grep
    sed
    ip
    nsenter
    awk
)

check_dependencies "${requirements[@]}"

readonly help_message="\
Usage: docker-veth.sh [OPTIONS]

Show virtual network interfaces associated with containers.

Options:
    --help    Display this help message and exit.

Example:
    $ docker-veth.sh
    Interface   Container ID    Container name
    eth0@if123  d7005eab838a    postgres_db
    eth1@if456  abcdef012345    container_name

    $ docker-veth.sh --help
    Display this help message and exit.
"

usage() { echo "$help_message"; }

get_veth() {
    local container_id
    local veth
    local networkmode
    local pid
    local ifindex

    # This function expects docker container ID as the first argument
    container_id="$1"
    veth=""
    networkmode=$(docker inspect -f "{{.HostConfig.NetworkMode}}" "$container_id")

    if [[ "$networkmode" == "host" ]]; then
        veth="host"
    else
        pid=$(docker inspect --format '{{.State.Pid}}' "$container_id")
        ifindex=$(sudo nsenter -t "$pid" -n ip link | sed -n -e 's/.*eth0@if\([0-9]*\):.*/\1/p')
        if [[ -z "$ifindex" ]]; then
            veth="not found"
        else
            veth=$(ip -o link | grep ^"$ifindex" | sed -n -e 's/.*\(veth[[:alnum:]]*@if[[:digit:]]*\).*/\1/p')
        fi
    fi

    echo "$veth"
}

main() {
    case "${1:-}" in
    -h | --help)
        usage
        exit 0
        ;;
    *) ;;
    esac

    local containerid
    local veth
    local containers

    echo -e "Interface\tContainer ID\tContainer name"
    containers=$(docker ps --format '{{.ID}}'"\t"'{{.Names}}' "$@")
    while IFS= read -r line; do
        containerid=$(echo "$line" | awk '{ print $1 }')
        veth=$(get_veth "$containerid")
        echo -e "$veth\t$line"
    done <<<"$containers"
}

main "$@"
