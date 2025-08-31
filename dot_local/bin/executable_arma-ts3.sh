#! /bin/sh
export PROTON_NO_ESYNC=1
export STEAM_COMPAT_DATA_PATH="/srv/steam_games/steamapps/compatdata/107410"
export STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/s1lv3r/.steam/steam"

"/srv/steam_games/steamapps/common/Proton 9.0 (Beta)/proton" run /srv/steam_games/steamapps/compatdata/107410/pfx/drive_c/Program\ Files/TeamSpeak\ 3\ Client/ts3client_win64.exe
