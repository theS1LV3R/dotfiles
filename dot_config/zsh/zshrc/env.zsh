export PATH=$PATH:~/.yarn/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:$GOPATH/bin

export EDITOR=nvim

ASDF=false

export ASDF_CONFIG_FILE=${XDG_CONFIG_HOME}/asdf/asdfrc

export ASDF_PYTHON_DEFAULT_PACKAGES_FILE=${XDG_CONFIG_HOME}/asdf/default-python-packages
export ASDF_NPM_DEFAULT_PACKAGES_FILE=${XDG_CONFIG_HOME}/asdf/default-npm-packages
export ASDF_GEM_DEFAULT_PACKAGES_FILE=${XDG_CONFIG_HOME}/asdf/default-gems

if [[ -f /opt/asdf-vm/asdf.sh ]]; then
  . /opt/asdf-vm/asdf.sh
  ASDF=true
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
  . $HOME/.asdf/asdf.sh
  ASDF=true
fi

if [[ "$ASDF" == true ]]; then
  rust_dir=$(asdf where rust)
  if [[ -n "$rust_dir" ]]; then
    source $rust_dir/env
  fi
fi

# tabtab source for netlify package
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh


# Load a local env file if it exists, for example secrets and stuff
if [[ -f $ZSH_SCRIPTS/env.local.zsh && -r $ZSH_SCRIPTS/env.local.zsh ]]; then
  source $ZSH_SCRIPTS/env.local.zsh
fi
