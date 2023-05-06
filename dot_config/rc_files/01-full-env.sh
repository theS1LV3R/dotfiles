#!/usr/bin/env bash
# vi: ft=sh

# Sources for a lot of these:
#   https://www.reddit.com/r/linux/comments/uouh7p/ - XDG ninja
#   https://wiki.archlinux.org/title/XDG_Base_Directory

# shellcheck source=00-xdg-env.sh
source /dev/null # Effectively a noop, only here for shellcheck

#! XDG_DATA_HOME
export WINEPREFIX="$XDG_DATA_HOME/wine"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export ANSIBLE_HOME="$XDG_DATA_HOME/ansible"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

#! XDG_CONFIG_HOME
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
#export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"

#! XDG_CACHE_HOME
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"

#! XDG_RUNTIME_DIR
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

#! Path
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
export PATH="./node_modules/.bin:$PATH"

#! Minikube
export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"
export MINIKUBE_SUBNET="10.246.0.1/16"

#! Docker/Podman
if command -v podman >/dev/null; then
    export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    export DOCKER_BUILDKIT=0
fi

#! Java stuff
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
export GRADLE_OPTS="-Djava.io.tmpdir=$XDG_CACHE_HOME/gradle"
export MAVEN_OPTS="-Dmaven.repo.local=$XDG_DATA_HOME/.m2/repository"

#! Postgres stuff
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"
export PGHOST="localhost"

#! Disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export STORYBOOK_DISABLE_TELEMETRY=1
export NEXT_TELEMETRY_DISABLED=1

#! Misc
# shellcheck disable=SC2016 # Expressions don't expand in single quotes, use double quotes for that.
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'

export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

# shellcheck disable=SC2155
# Declare and assign separately to avoid masking return values.
export GPG_TTY=$(tty) # When making commits during SSH, so GPG uses the TTY and doesnt break

#! ASDF
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-python-packages"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-npm-packages"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-gems"
export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-go-packages"

# https://github.com/alacritty/alacritty/issues/3465
export WINIT_X11_SCALE_FACTOR=1

# https://old.reddit.com/r/kde/comments/kzjo9d
export GTK_USE_PORTAL=1

if [[ -n "$SSH_CONNECTION" ]]; then
    # Use a terminal for GPG passwords if going over SSH
    export PINENTRY_USER_DATA="USE_CURSES=1"
fi

export EDITOR="nvim"
export VISUAL="nvim"

export PROMPT_EOL_MARK=""