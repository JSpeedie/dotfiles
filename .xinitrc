[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
xset +fp ~/.fonts/tamzen-font/bdf
xset +fp ~/.fonts
xset fp rehash
xset -dpms
xset s off
xset r rate 330 50
xrandr --output DVI-I-O --mode 1920x1080 --pos 0x0 --output HDMI-0 --primary --mode 2560x1440 --pos 1920x0 --rotate left --output DVI-D-0 --mode 1920x1080 --pos 3360x0 --rotate normal
xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
sh ~/scripts/lbarout.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/LifeGuardPostAtBeach.jpe &
compton -b -f -D 5 -O 0.05 --config ~/compton.conf &
sh ~/scripts/start.sh &
exec sxhkd
# exec bspwm
