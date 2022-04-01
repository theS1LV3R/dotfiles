if [[ -f /usr/bin/lsd ]] then;
    alias ls='lsd --color=auto'
fi;

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -F'
alias lah='ls -lah'

alias open='xdg-open'

# Alias for cloudflared, because its easier to type
alias cfd='cloudflared'

# Nvim alias for vim
if (( $+commands[nvim] )); then alias vim='nvim'; fi;
if (( $+commands[bat]  )); then alias cat='bat' ; fi;

# Termbin
alias tb='nc termbin.com 9999'

alias grep='grep --color'

alias c=clear

# Systemctl aliases
alias start="sudo systemctl start "
alias restart="sudo systemctl restart "
alias stop="sudo systemctl stop "
alias enable="sudo systemctl enable "
alias disable="sudo systemctl disable "
alias mask="sudo systemctl mask "
alias unmask="sudo systemctl unmask "
alias status="sudo systemctl status "
alias reload="sudo systemctl reload "

wttr() {
    curl "https://wttr.in/$1?0FmM&lang=en"
}

cheat() {
    curl "https://cheat.sh/$1"
}

alias  path="echo  $PATH | sed 's/:/\n/g'"
alias fpath="echo $FPATH | sed 's/:/\n/g'"

secret() {
    bytes="64"

    if [ $# -ne 0 ]; then bytes="$*"; fi
    
    openssl rand -hex $bytes
}

alias jwt="jq -R 'split(\".\") | select(length > 0) | .[0],.[1] | @base64d | fromjson'"

fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

[[ -f /opt/asdf-vm/asdf.sh ]] && . /opt/asdf-vm/asdf.sh
