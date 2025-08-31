#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=bash:ts=4:sw=4

# Sources for a lot of these:
#   https://www.reddit.com/r/linux/comments/uouh7p/ - XDG ninja
#   https://wiki.archlinux.org/title/XDG_Base_Directory

# shellcheck source=00-xdg-env.sh
source /dev/null # Effectively a noop, only here for shellcheck

#! XDG_DATA_HOME
export WINEPREFIX="$XDG_DATA_HOME/wine"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export ANDROID_USER_HOME="$ANDROID_HOME"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export ANSIBLE_HOME="$XDG_DATA_HOME/ansible"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export SQLITE_HISTORY="$XDG_CACHE_HOME/sqlite_history"
export MANPATH="$XDG_DATA_HOME/man:$MANPATH"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

#! XDG_CONFIG_HOME
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
#export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export KDEHOME="$XDG_CONFIG_HOME/kde"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export PARALLEL_HOME="$XDG_CONFIG_HOME/parallel"
export STREAMDECK_UI_CONFIG="$XDG_CONFIG_HOME/streamdeck-ui.json"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export MC_CONFIG_DIR="$XDG_CONFIG_HOME/minio_cli"

#! XDG_CACHE_HOME
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages"
export DVDCSS_CACHE="$XDG_CACHE_HOME/dvdcss"

#! XDG_RUNTIME_DIR
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

#! Path
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
#export PATH="./node_modules/.bin:$PATH"

#! Minikube
export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"
export MINIKUBE_SUBNET="10.240.30.1/24"
export MINIKUBE_DRIVER=docker
export MINIKUBE_ROOTLESS=false

#! Java stuff
java_opts_arr=(
    "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
    "-Dawt.useSystemAAFontSettings=on"
    "-Dswing.aatext=true"
    "-Djava.io.tmpdir=$XDG_CACHE_HOME/java"
)
export _JAVA_OPTIONS="${java_opts_arr[*]}"
unset java_opts_arr

#! Postgres stuff
export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"
export PGHOST="localhost"
export PG_COLOR="auto"
export PGPASSFILE="$XDG_DATA_HOME/psql/pgpass"

#! Disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export STORYBOOK_DISABLE_TELEMETRY=1 # https://storybook.js.org/docs/configure/telemetry#how-to-opt-out
export BENTOML_DO_NOT_TRACK=True
export NEXT_TELEMETRY_DISABLED=1  # https://nextjs.org/telemetry
export ASTRO_TELEMETRY_DISABLED=1 # https://astro.build/telemetry/

#! ASDF
export ASDF_CONFIG_FILE="$XDG_CONFIG_HOME/asdf/asdfrc"
export ASDF_DATA_DIR="$XDG_DATA_HOME/asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-python-packages"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-npm-packages"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-gems"
export ASDF_GOLANG_DEFAULT_PACKAGES_FILE="$XDG_CONFIG_HOME/asdf/default-go-packages"
export ASDF_NODEJS_AUTO_ENABLE_COREPACK=true

#! Misc
# SC2016 - Expressions don't expand in single quotes, use double quotes for that.
# shellcheck disable=SC2016
export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.lua" | so $MYVIMRC'

# SC2155 - Declare and assign separately to avoid masking return values.
# shellcheck disable=SC2155
# When making commits over SSH, fall back to the current TTY. If $DISPLAY is set it uses that regardless
export GPG_TTY=$(tty)

# https://github.com/alacritty/alacritty/issues/3465
export WINIT_X11_SCALE_FACTOR=1

# Use xdg-desktop-portal to use native file pickers and such
# https://old.reddit.com/r/kde/comments/kzjo9d
export GTK_USE_PORTAL=1

if [[ -n "${SSH_CONNECTION:-}" ]]; then
    # Use a terminal for GPG passwords if going over SSH
    export PINENTRY_USER_DATA="USE_CURSES=1"
fi

# https://wiki.archlinux.org/title/Firefox#Wayland
if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
    export MOZ_ENABLE_WAYLAND=1
fi

export EDITOR="nvim"
export VISUAL="nvim"
BROWSER="$(xdg-settings get default-web-browser | sed -e 's|\.desktop$||' || true)"
export BROWSER

export PROMPT_EOL_MARK=""
