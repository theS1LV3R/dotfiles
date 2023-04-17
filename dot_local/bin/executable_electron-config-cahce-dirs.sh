#!/usr/bin/env bash

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

search_dir="$HOME/.config"

find_dirs=(
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
)

for dir in "${find_dirs[@]}"; do
    sanitized=${dir// /_}
    sanitized=${sanitized,,}

    checked_dirs=$(find "$search_dir" -type d -iname "$dir")

    echo "Cleaning '$dir'"
    while IFS= read -r source; do
        [[ -z $source ]] && continue
        mini_source=${source//"$search_dir/"/}
        target="${XDG_CACHE_HOME:-"$HOME/.cache"}/$mini_source"

        mkdir -p "$(dirname "$target")"

        echo ".config/$mini_source -> $target"

        mv "$source" "$target"
        # ln [TARGET] [LINK NAME]
        ln -s "$target" "$source"
    done <<<"$checked_dirs"
done
