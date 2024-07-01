#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# shellcheck source=executable___common.sh
source "$HOME/.local/bin/__common.sh"

readonly search_dirs=(
    "$XDG_CONFIG_HOME"
    "$HOME/.vscode"
)

readonly dirs=(
    "Crash Reports"
    "Media Cache"
    "Code Cache"
    CacheStorage
    CachedData
    GPUCache
    Cache
    blob_storage
    workspaceStorage
    CachedExtensionVSIXs
    ShaderCache
)

for search_dir in "${search_dirs[@]}"; do
    echo ">>> Searching in $search_dir"
    for dir in "${dirs[@]}"; do
        sanitized=${dir// /_} # Replace spaces with _
        sanitized=${sanitized,,}    # Convert to lowercase

        # Find every directory "$dir" in "$search_dir"
        checked_dirs=$(find "$search_dir" -type d -iname "$dir")

        echo "--- Cleaning '$dir'"
        while IFS= read -r source; do
            # Skip over empty sources
            [[ -z $source ]] && continue

            # Remove search_dir from the resolved path, only leaving the path inside
            mini_source=${source//"$search_dir/"/}

            # Specify where the symlink sould be created
            target="${XDG_CACHE_HOME:-"$HOME/.cache"}/$mini_source"

            # Ensure the folder exists before adding the symlink
            mkdir -p "$(dirname "$target")"

            echo "$source -> $target"

            # If we can't move the source directory to the target, move the contents and remove the source
            if ! mv -v "$source" "$target"; then
                mv -v "$source/"* "$target" || true
                rm -rf "$source"
            fi

            # Create the symlink
            # ln [TARGET] [LINK NAME]
            ln -s "$target" "$source"
        done <<<"$checked_dirs"
    done
done
