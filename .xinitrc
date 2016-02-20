[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
xset -dpms
xset s off
xrandr --output HDMI-0 --left-of DVI-D-0 &
xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
sxhkd &
sh ~/.lemonbarscripts/lbarout.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/LifeGuardPostAtBeach.jpe &
compton -b -f -D 5 -O 0.05 --config ~/compton.conf &
sh start.sh &
exec bspwm 
