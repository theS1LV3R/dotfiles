#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

readonly baseurl="https://github.com/romkatv/powerlevel10k-media/raw/master/"
readonly font_dir="$HOME/.local/share/fonts"

readonly font_names=(
    "MesloLGS NF Regular"
    "MesloLGS NF Bold"
    "MesloLGS NF Italic"
    "MesloLGS NF Bold Italic"
)

process() {
    local font_name="$1"

    local urlencoded_name="${font_name// /\%20}"
    local filename="${font_name// /_}"

    local source_url="$baseurl/$urlencoded_name.ttf"
    local output_file="$font_dir/$filename.ttf"

    if [[ ! -f "$output_file" ]]; then
        curl -L "$source_url" -o "$output_file"
    fi
}

mkdir -p "$font_dir"

for font_name in "${font_names[@]}"; do
    process "$font_name"
done

fc-cache -f -v
