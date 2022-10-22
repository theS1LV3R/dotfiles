# Dotfiles

## All of this is outdated. Dont use it.

These are the dotfiles i chose to keep between my linux installs. Nothing really special about them.

## Requirements

The dotfiles themselves don't have any requirements other than to have their
respective programs installed. For example `vim` for [`vimrc`](./vimrc).

Uses chezmoi for dotfile management.

## Cloning and installing

```bash
# If you already have chezmoi installed
# NOTE: May overwrite already existing dotfiles
chezmoi init --apply theS1LV3R

# If chezmoi is not installed
# NOTE: May overwrite already existing dotfiles
# NOTE: May install itself to $HOME/.local/bin/chezmoi
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply theS1LV3R
```

## See also

Much of this repo was inspired by [tapayne88/dotfiles](https://github.com/tapayne88/dotfiles)

## License

MIT license. See [`./LICENSE`](./LICENSE)
