#!/bin/bash
ICON=$HOME/LockIcon.png
BG=/tmp/screen.png
scrot /tmp/screen.png
convert $BG -scale 10% -scale 1000% $BG
convert $BG $ICON -gravity center -composite -matte $BG
i3lock -u -i $BG
