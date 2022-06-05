# enable completion features (see under)
autoload -Uzd bashcompinit && bashcompinit
# compinit -d ~/.cache/zcompdump
complete -C '/usr/bin/aws_completer' aws

# tabtab source for netlify and pnpm
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh
