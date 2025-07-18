#!/bin/sh

#########################
# Default xinitrc stuff #
#########################

# Set up a clean environment for X11 session. Right now I use i3, so I set
# the exports accordingly
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=i3
export XDG_SESSION_DESKTOP=i3
export XDG_SESSION_CLASS=user
export DESKTOP_SESSION=i3
export QT_QPA_PLATFORM=xcb  # helps with Qt apps in X11
export GDK_BACKEND=x11      # helps with GTK apps in X11

# Ensure dbus is running. I found this to be necessary to make nautilus load in
# a reasonable amount of time on a display-manager-less Debian setup.
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax)"
fi

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

#########################
# Monitor configuration #
#########################
# 1. My script for configuring my monitors. Downside: difficult to change if I add
# another monitor or just change my monitor setup in general
# $(~/scripts/getxrandr)

# 2. Alternative to my `xrandr` script. Downside: there's no way to set refresh
# rate with `arandr` it seems.
# ./.screenlayout/desktop.sh

# 3. Settled on solution: run `sudo nvidia-settings`, go to "X Server Display
# Configuration", configure your monitors there, and "Save to X Configuration
# File"
# sudo nvidia-settings

xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
~/scripts/bar &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/plants.jpg &
# The first 3 flags are to eliminate tearing, following flags are for shadows
# and fade effects
# compton --backend glx --paint-on-overlay --vsync opengl-swc -b -f --fade-delta 2 -O 0.05 --shadow-opacity 0.5 --config ~/compton.conf &
# Picom replaces compton
picom --config .config/picom/picom.conf &
# Start our authentication agent (so we get GUI password prompts when we
# attempt to perform an operation that requires root access in a GUI
# application)
# For Manjaro and Arch(?)
if [ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
	/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi
# For Debian
if [ -x /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]; then
	/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
fi
# sh ~/scripts/start.sh &
[ ! -s ~/.config/mpd/pid ] && mpd ~/.config/mpd/mpd.conf
numlockx &
exec i3
