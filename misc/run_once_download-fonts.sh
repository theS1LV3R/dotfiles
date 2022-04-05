#!/usr/bin/env bash

baseurl="https://github.com/romkatv/powerlevel10k-media/raw/master/{}.ttf"

types=(
    "MesloLGS NF Regular"
    "MesloLGS NF Bold"
    "MesloLGS NF Italic"
    "MesloLGS NF Bold Italic"
)

for type in "${types[@]}"; do
    font_url=${type// /\%20}
    filename=${type// /_}

    url=${baseurl//\{\}/$font_url}
    file="$HOME/.local/share/fonts/$filename.ttf"

    if [ ! -f "$file" ]; then
        curl -L "$url" -o "$file"
    fi
done

fc-cache -f -v
