[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
xset -dpms
xset s off
xrandr --output DP-1 --off --output DVI-I-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DVI-D-1 --off --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal
xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
sxhkd &
sh ~/.lemonbarscripts/lbarout.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/LifeGuardPostAtBeach.jpe &
compton -b -f -D 5 -O 0.05 --config ~/compton.conf &
sh ~/scripts/start.sh &
exec bspwm 
