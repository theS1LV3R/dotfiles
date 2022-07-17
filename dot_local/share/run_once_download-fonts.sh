#!/usr/bin/env bash

baseurl="https://github.com/romkatv/powerlevel10k-media/raw/master/{}.ttf"

types=(
    "MesloLGS NF Regular"
    "MesloLGS NF Bold"
    "MesloLGS NF Italic"
    "MesloLGS NF Bold Italic"
)
font_dir="${HOME}/.local/share/fonts"

mkdir -p "${font_dir}"

for type in "${types[@]}"; do
    font_url=${type// /\%20}
    filename=${type// /_}

    url=${baseurl//\{\}/${font_url}}
    file="${font_dir}/${filename}.ttf"

    if [[ ! -f "${file}" ]]; then
        curl -L "${url}" -o "${file}"
    fi
done

fc-cache -f -v
