functions_to_create=(
  'node'
  'nvm'
  'yarn'
  'npm'
  'code'
  'nvim'
  'tmux'
)

# Loop through the array of functions to create and create them
for function in "${functions_to_create[@]}"; do
  eval "function $function() {
    unset -f $functions_to_create &> /dev/null

    load_nvm

    $function \$@
  }"
done

load_nvm() {
  if [[ $__NVM_LOADED -ne 1 ]]; then
  echo -n "Loading nvm... "

  # =======================================================================================
  if [[ -f /usr/share/nvm/init-nvm.sh ]]; then # nvm on arch
    source /usr/share/nvm/init-nvm.sh
  # =======================================================================================
  elif [[ -d $HOME/.nvm ]]; then # default nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # nvm bash completion
  # =======================================================================================
  fi

  echo "Done"

  export __NVM_LOADED=1
  fi
}

