# For easier folder management in scripts. Will be fixed eventually
# so it loads dynamically from where the dotfiles are located
export SCRIPTS_DIR=~/.dotfiles/scripts

# Load antigen (Plugin manager)
source ~/.dotfiles/antigen/antigen.zsh

# p10k (Prompt)
source $SCRIPTS_DIR/p10k.init.zsh

# Everything else zsh related
source $SCRIPTS_DIR/zsh.init.zsh

antigen theme romkatv/powerlevel10k
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply
unset SCRIPTS_DIR
