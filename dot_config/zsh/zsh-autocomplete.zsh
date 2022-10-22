zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion

typeset -A key
key=(
    BackSpace "${terminfo[kbs]}"
    Home "${terminfo[khome]}"
    End "${terminfo[kend]}"
    Insert "${terminfo[kich1]}"
    Delete "${terminfo[kdch1]}"
    Up "${terminfo[kcuu1]}"
    Down "${terminfo[kcud1]}"
    Left "${terminfo[kcub1]}"
    Right "${terminfo[kcuf1]}"
    PageUp "${terminfo[kpp]}"
    PageDown "${terminfo[knp]}"
    Control-Space "${terminfo[kcbt]}"
    Return "${terminfo[cr]}"
)

##################################################
#
#         vv ZSH AUTOCOMPLETE OPTIONS vv
#
#################################################

# The code below sets all of `zsh-autocomplete`'s settings to their default
# values. To change a setting, copy it into your `.zshrc` file.

zstyle ':autocomplete:*' default-context ''
# '': Start each new command line with normal autocompletion.
# history-incremental-search-backward: Start in live history search mode.

zstyle ':autocomplete:*' min-delay 0.2 # number of seconds (float)
# 0.0: Start autocompletion immediately when you stop typing.
# 0.4: Wait 0.4 seconds for more keyboard input before showing completions.

zstyle ':autocomplete:*' min-input 2 # number of characters (integer)
# 0: Show completions immediately on each new command line.
# 1: Wait for at least 1 character of input.

zstyle ':autocomplete:*' ignored-input '' # extended glob pattern
# '':     Always show completions.
# '..##': Don't show completions when the input consists of two or more dots.

zstyle ':autocomplete:*' list-lines 8 # int
# If there are fewer than this many lines below the prompt, move the prompt up
# to make room for showing this many lines of completions (approximately).

zstyle ':autocomplete:history-search:*' list-lines 8 # int
# Show this many history lines when pressing ↑.

zstyle ':autocomplete:history-incremental-search-*:*' list-lines 4 # int
# Show this many history lines when pressing ⌃R or ⌃S.

zstyle ':autocomplete:*' recent-dirs cdr
# cdr:  Use Zsh's `cdr` function to show recent directories as completions.
# no:   Don't show recent directories.
# zsh-z|zoxide|z.lua|z.sh|autojump|fasd: Use this instead (if installed).
# ⚠️ NOTE: This setting can NOT be changed at runtime.

# If any of the following are shown at the same time, list them in this order:
zstyle ':completion:*:' group-order \
    expansions history-words options \
    aliases functions builtins reserved-words \
    executables local-directories directories suffix-aliases
# 💡 NOTE: This is NOT the order in which they are generated.

zstyle ':autocomplete:*' insert-unambiguous yes
# no:  Tab inserts the top completion.
# yes: Tab first inserts substring common to all listed completions, if any.

zstyle ':autocomplete:*' widget-style menu-select
# complete-word: (Shift-)Tab inserts the top (bottom) completion.
# menu-complete: Press again to cycle to next (previous) completion.
# menu-select:   Same as `menu-complete`, but updates selection in menu.
# ⚠️ NOTE: This can NOT be changed at runtime.

zstyle ':autocomplete:*' fzf-completion yes
# no:  Tab uses Zsh's completion system only.
# yes: Tab first tries Fzf's completion, then falls back to Zsh's.
# ⚠️ NOTE: This can NOT be changed at runtime and requires that you have
# installed Fzf's shell extensions.

# Add a space after these completions:
zstyle ':autocomplete:*' add-space \
    executables aliases functions builtins reserved-words commands

source ${DOTFILES_DIR}/zsh_plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
#
# NOTE: All settings below should come AFTER sourcing zsh-autocomplete!
#

bindkey $key[Up] up-line-or-history
# up-line-or-search:  Open history menu.
# up-line-or-history: Cycle to previous history line.

bindkey $key[Down] down-line-or-history
# down-line-or-select:  Open completion menu.
# down-line-or-history: Cycle to next history line.

bindkey $key[Control-Space] list-expand
# list-expand:      Reveal hidden completions.
# set-mark-command: Activate text selection.

bindkey -M menuselect $key[Return] accept-line
# .accept-line: Accept command line.
# accept-line:  Accept selection and exit menu.

# Uncomment the following lines to disable live history search:
# zle -A {.,}history-incremental-search-forward
# zle -A {.,}history-incremental-search-backward

# Return key in completion menu & history menu:
bindkey -M menuselect $key[Return]  accept-line
# .accept-line: Accept command line.
# accept-line:  Accept selection and exit menu.
