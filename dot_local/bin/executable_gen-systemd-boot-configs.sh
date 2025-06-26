#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

options=(
    "root=UUID=68fcb964-76d2-461c-9403-7116e6958db0"
    "rootfstype=ext4"
    "rw"

    "loglevel=3"
    "noplymouth"
    "zswap.enabled=1"
)

readonly hibernate_options=(
    "resume=UUID=bc3ff9e8-e7cb-4e45-b518-2f2fc8c4ba02"
    "mem_sleep_default=deep"
)

readonly kernels=(
    linux
    linux-lts
)
readonly initramfses=(
    ""
    -fallback
)

#options+=("${hibernate_options[@]}")
readonly options

sort_key=0
for kernel in "${kernels[@]}"; do
    for initramfs in "${initramfses[@]}"; do
        ((sort_key += 10))
        cat <<EOF
# Created by: $(basename "$0")
# Created on: $(date +%Y-%m-%d_%H-%M-%S)
title       Arch ($kernel$initramfs)
sort-key    $sort_key
linux       /vmlinux-$kernel
initrd      /amd-ucode.img
initrd      /initramfs-$kernel$initramfs.img
options     ${options[@]}
EOF
    done
done
