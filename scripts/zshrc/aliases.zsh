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
