#!/usr/bin/env zsh

setopt prompt_subst
autoload -U colors && colors # Enable colors in prompt

red="%{$fg[red]%}"
cyan="%{$fg[cyan]%}"
magenta="%{$fg[magenta]%}"
yellow="%{$fg[yellow]%}"
green="%{$fg[green]%}"
blue="%{$fg[blue]%}"
nc="%{$reset_color%}"

# Echoes a username/host string when connected over SSH (empty otherwise)
ssh_info() {
  [[ "$SSH_CONNECTION" != '' ]] && echo '%(!.${red}.${yellow})%n$nc@${green}%m$nc:' || echo ''
}

# Echoes information about Git repository status when inside a Git repository
git_info() {

  # Exit if not inside a Git repository
  ! git rev-parse --is-inside-work-tree > /dev/null 2>&1 && return

  # Git branch/tag, or name-rev if on detached head
  local GIT_LOCATION=${$(git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD)#(refs/heads/|tags/)}

  local AHEAD="$red↑NUM$nc"
  local BEHIND="$cyan↓NUM$nc"
  local MERGING="$magenta‼$nc"
  local UNTRACKED="$red○$nc"
  local MODIFIED="$yellow○$nc"
  local STAGED="$green○$nc"

  local -a DIVERGENCES
  local -a FLAGS

  local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  if [[ "$NUM_AHEAD" -gt 0 ]]; then
    DIVERGENCES+=( "${AHEAD//NUM/$NUM_AHEAD}" )
  fi

  local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  if [[ "$NUM_BEHIND" -gt 0 ]]; then
    DIVERGENCES+=( "${BEHIND//NUM/$NUM_BEHIND}" )
  fi

  local GIT_DIR="$(git rev-parse --git-dir 2> /dev/null)"
  if [[ -n $GIT_DIR ]] && test -r $GIT_DIR/MERGE_HEAD; then
    FLAGS+=( "$MERGING" )
  fi

  if [[ -n $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    FLAGS+=( "$UNTRACKED" )
  fi

  if ! git diff --quiet 2> /dev/null; then
    FLAGS+=( "$MODIFIED" )
  fi

  if ! git diff --cached --quiet 2> /dev/null; then
    FLAGS+=( "$STAGED" )
  fi

  local -a GIT_INFO
  GIT_INFO+=( "\033[38;5;15m±" )
  [[ -n "$GIT_STATUS" ]] && GIT_INFO+=( "$GIT_STATUS" )
  [[ ${#DIVERGENCES[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)DIVERGENCES}" )
  [[ ${#FLAGS[@]} -ne 0 ]] && GIT_INFO+=( "${(j::)FLAGS}" )
  GIT_INFO+=( "\033[38;5;15m$GIT_LOCATION$nc" )
  echo "${(j: :)GIT_INFO}"
}

# Use > as the non-root prompt character; # for root
# Change the prompt character color if the last command had a nonzero exit code
PS1='
$(ssh_info)$magenta%~%u $(git_info)
%(?.$blue.$red)%(!.#.>)$nc '

unset red
unset cyan
unset magenta
unset yellow
unset green
unset blue
unset nc
