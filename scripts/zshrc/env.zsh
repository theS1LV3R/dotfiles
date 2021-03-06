export PATH=$PATH:~/.yarn/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:~/.local/bin

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# Enable nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # nvm bash completion

# Load a local env file if it exists, for example secrets and stuff
if [[ -f $SCRIPTS_DIR/zshrc/env.local.zsh && -r $SCRIPTS_DIR/zshrc/env.local.zsh ]]; then
  source $SCRIPTS_DIR/zshrc/env.local.zsh
fi

export EDITOR=vim
