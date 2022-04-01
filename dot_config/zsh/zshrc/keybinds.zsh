# configure key keybindings
bindkey -e                                     # emacs key bindings
bindkey ' ' magic-space                        # do history expansion on space
bindkey '^[[3;5~' kill-word                    # ctrl + Supr
bindkey '^[[1;5C' forward-word                 # ctrl + ->
bindkey '^[[1;5D' backward-word                # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history # page up
bindkey '^[[6~' end-of-buffer-or-history       # page down
bindkey '^[[Z' undo                            # shift + tab undo last action
bindkey '^[[3~' delete-char                    # Delete/DEL
