ASDF=false

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

export PATH="$PATH:$GOPATH/bin"

[[ -x $ZSH_SCRIPTS/env.local.zsh ]] && source $ZSH_SCRIPTS/env.local.zsh
