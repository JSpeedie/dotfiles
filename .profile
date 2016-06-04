export XDG_CONFIG_HOME="$HOME/.config"
export SHELL=/bin/bash
if [ -t 1 ]; then exec $SHELL; fi
[ ! -s ~/.config/mpd/pid ] && mpd
