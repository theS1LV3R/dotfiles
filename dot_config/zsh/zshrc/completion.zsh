complete -C "$HOME/.local/bin/aws_completer" aws

for program (
    netlify
    pnpm
) do;
    [[ -f ~/.config/tabtab/$program.zsh ]] && source ~/.config/tabtab/$program.zsh || true
done
