# Originally sourced from zshrc file
# Everything is sourced in the order it was in the original dotfile

setopt AUTO_PUSHD          # automatically push to the directory stack
setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt extended_history    # include timestamps in history
setopt share_history       # share history between all sessions
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt no_beep             # don't beep on errors
setopt C_BASES             # 0xFF instead of 16#FF
setopt COMPLETE_ALIASES

#! GENERATES ERRORS - DO NOT USE
# setopt ksharrays           # arrays start at 0

WORDCHARS=${WORDCHARS//\//} # Don't consider certain characters part of the word

# hide EOL sign ('%')
export PROMPT_EOL_MARK=""

export ZSH_SCRIPTS=$SCRIPTS_DIR/zshrc

source $ZSH_SCRIPTS/keybinds.zsh
source $ZSH_SCRIPTS/completion.zsh
source $ZSH_SCRIPTS/history.zsh
source $ZSH_SCRIPTS/env.zsh
source $ZSH_SCRIPTS/colors.zsh
source $ZSH_SCRIPTS/aliases.zsh
source $ZSH_SCRIPTS/functions.zsh
source $ZSH_SCRIPTS/wsl.zsh

unset ZSH_SCRIPTS
