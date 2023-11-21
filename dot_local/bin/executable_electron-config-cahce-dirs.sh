#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly search_dirs=(
    "$XDG_CONFIG_HOME"
    "$HOME/.vscode"
)

readonly find_dirs=(
    "Crash Reports"
    "Media Cache"
    "Code Cache"
    CacheStorage
    CachedData
    GPUCache
    Cache
    blob_storage
    logs
    workspaceStorage
    CachedExtensionVSIXs
    ShaderCache
)

for sdir in "${search_dirs[@]}"; do
    for dir in "${find_dirs[@]}"; do
        sanitized=${dir// /_}
        sanitized=${sanitized,,}

        checked_dirs=$(find "$sdir" -type d -iname "$dir")

        echo "Cleaning '$dir'"
        while IFS= read -r source; do
            [[ -z $source ]] && continue
            mini_source=${source//"$sdir/"/}
            target="${XDG_CACHE_HOME:-"$HOME/.cache"}/$mini_source"

            mkdir -p "$(dirname "$target")"

            echo "$source -> $target"

            if ! mv -v "$source" "$target"; then
                mv -v "$source" "$target-2"
            fi

            # ln [TARGET] [LINK NAME]
            ln -s "$target" "$source"
        done <<<"$checked_dirs"
    done
done
