#!/usr/bin/env bash

if command -v starship &> /dev/null
then
    echo "Starship is already installed"
    exit 0
else
    echo "Installing starship"
    curl -fsSL https://starship.rs/install.sh | bash
    exit 0
fi
