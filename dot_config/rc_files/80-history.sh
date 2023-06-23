#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

[[ -n "$ZSH_VERSION" ]] && export HISTFILE="$XDG_DATA_HOME/.zsh_history" # The file to save the history in when an interactive shell exits.  If unset, the history is not saved.
[[ -n "$BASH_VERSION" ]] && export HISTFILE="$XDG_DATA_HOME/bash/history"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=25000 # The  maximum  number  of  events  stored  in  the  internal  history  list.
SAVEHIST=20000 # The maximum number of history events to save in the history file.
HISTFILESIZE=$SAVEHIST

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
[[ -n "$BASH_VERSION" ]] && HISTCONTROL=ignoreboth
