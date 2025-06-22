#!/bin/sh

#########################
# Default xinitrc stuff #
#########################
userresources=$HOME/.Xresources-ayu
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

####################
# My configuration #
####################
$HOME/.monicarc   # monitor calibration
xset +fp ~/.fonts/tamzen-font/bdf
xset +fp /usr/share/fonts/local/
xset +fp ~/.fonts
xset fp rehash &
xset -dpms &
xset s off &
xset r rate 250 50 &
# Placeholder until I fix the script
# xrandr --output DP-0 --mode 1920x1080 --rate 144.00 --left-of DP-2 --output DP-2 --mode 2560x1440 --rate 59.95 --primary 
$(sh ~/scripts/getxrandr.sh)
xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
sh ~/scripts/bar.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/plants.jpg &
# The first 3 flags are to eliminate tearing, following flags are for shadows
# and fade effects
# compton --backend glx --paint-on-overlay --vsync opengl-swc -b -f --fade-delta 2 -O 0.05 --shadow-opacity 0.5 --config ~/compton.conf &
# Picom replaces compton
picom --config .config/picom/picom.conf &
# Start our authentication agent (so we get GUI password prompts when we
# attempt to perform an operation that requires root access in a GUI application)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# sh ~/scripts/start.sh &
[ ! -s ~/.config/mpd/pid ] && mpd ~/.config/mpd/mpd.conf
numlockx &
exec i3
