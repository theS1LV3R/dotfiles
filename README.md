# Dotfiles

These are the dotfiles i chose to keep between my linux installs. Nothing really special about them.

## Requirements

The dotfiles themselves don't have any requirements other than to have their
respective programs installed. For example `vim` for [`vimrc`](./vimrc).

For automatic installation with the install script (see below) Python 3 or
above is required.

## Cloning and installing

```bash
# Clone the repo
# ssh
git clone git@github.com:theS1LV3R/dotfiles.git ~/.dotfiles

# https
git clone https://github.com:theS1LV3R/dotfiles.git ~/.dotfiles

# Enter into the repo
cd ~/.dotfiles

# Install dotfiles using dotbot
chmod +x install && ./install
```

## Screenshot

![screenshot of desktop](./screenshot.png)
