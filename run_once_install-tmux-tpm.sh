#!/bin/bash

[ -d ~/.tmux ] || mkdir ~/.tmux
[ -d ~/.tmux/plugins ] || mkdir ~/.tmux/plugins

[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
