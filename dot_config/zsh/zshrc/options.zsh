#! GENERATES ERRORS - DO NOT USE
# setopt KSH_ARRAYS           # arrays start at 0

# why zsh only?
# - setopt is a zsh command
# - zsh specific HISTFILE

setopt AUTO_CD             # change directory just by typing its name
setopt AUTO_PUSHD          # automatically push to the directory stack
setopt PUSHD_IGNORE_DUPS   # don't push the same directory twice
setopt CORRECT             # auto correct mistakes
setopt INTERACTIVECOMMENTS # allow comments in interactive mode
setopt EXTENDED_HISTORY    # include timestamps in history
setopt SHARE_HISTORY       # share history between all sessions
setopt MAGIC_EQUAL_SUBST   # enable filename expansion for arguments of the form ‘anything=expression’
setopt NO_NOMATCH          # hide error message if there is no match for the pattern
setopt NOTIFY              # report the status of background jobs immediately
setopt NUMERIC_GLOB_SORT   # sort filenames numerically when it makes sense
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt NO_BEEP             # don't beep on errors
setopt C_BASES             # 0xFF instead of 16#FF
setopt COMPLETE_ALIASES    # enable alias completion
setopt MAIL_WARNING        # warn if mail file has been accessed

setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE      # ignore commands that start with space
setopt HIST_VERIFY            # show command with history expansion to user before running it

WORDCHARS=${WORDCHARS//\//} # Don't consider certain characters part of the word
