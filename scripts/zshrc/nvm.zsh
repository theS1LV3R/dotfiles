# https://github.com/ravron/dotfiles/blob/2093bb4b257db221f31fa900cfc8cd394476a7cd/.bashrc#L233-L243
nvm() {
  unset $funcstack[1]

  if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
    source /usr/share/nvm/init-nvm.sh
  elif [[ -d $HOME/.nvm ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # nvm bash completion
  fi

  nvm "@"
}
