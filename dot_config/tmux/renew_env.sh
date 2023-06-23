#!/usr/bin/env bash
# vi: ft=bash:ts=4:sw=4

set -euo pipefail

pane_fmt="#{pane_id} #{pane_in_mode} #{pane_input_off} #{pane_dead} #{pane_current_command}"

# If -a is given, target is ignored and all panes on the server are listed.  If -s is given, target is a
# session (or the current session).  If neither is given, target is a window (or the current window).  -F
# specifies the format of each line and -f a filter.  Only panes for which the filter is true are shown.
# See the FORMATS section.
pane_ids=$(tmux list-panes -s -F "$pane_fmt" | awk '$2 == 0 && $3 == 0 && $4 == 0 && $5 ~ /(bash|zsh|ksh|fish)/ { print $1 }')

while read -r pane_id <<<"$pane_ids"; do
  # renew environment variables according to update-environment tmux option
  # also clear screen
  # shellcheck disable=SC2016
  tmux send-keys -t "$pane_id" 'Enter' 'eval "$(tmux show-env -s)"' 'Enter' 'C-l'
done
