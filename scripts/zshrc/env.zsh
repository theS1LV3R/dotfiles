export PATH=$PATH:~/.yarn/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:$GOPATH/bin

# Disable dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=true

# Enable nvm
source $ZSH_SCRIPTS/nvm.zsh

[[ -s ~/.gvm/scripts/gvm ]] && source ~/.gvm/scripts/gvm

export EDITOR=vim

if [[ -n "$SSH_CONNECTION" ]]; then
  export PINENTRY_USER_DATA="USE_CURSES=1"
fi

# Load a local env file if it exists, for example secrets and stuff
if [[ -f $ZSH_SCRIPTS/env.local.zsh && -r $ZSH_SCRIPTS/env.local.zsh ]]; then
  source $ZSH_SCRIPTS/env.local.zsh
fi

