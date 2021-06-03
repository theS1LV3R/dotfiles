export PATH=$PATH:~/.yarn/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:~/.local/bin

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# Enable nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # nvm bash completion

if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
  source /usr/share/nvm/init-nvm.sh
fi

# Load a local env file if it exists, for example secrets and stuff
if [[ -f $ZSH_SCRIPTS/env.local.zsh && -r $ZSH_SCRIPTS/env.local.zsh ]]; then
  source $ZSH_SCRIPTS/env.local.zsh
fi

[[ -s ~/.gvm/scripts/gvm ]] && source ~/.gvm/scripts/gvm

export EDITOR=vim
