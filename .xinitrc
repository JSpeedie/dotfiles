xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
xset +fp ~/.fonts/tamzen-font/bdf
xset +fp /usr/share/fonts/local/
xset +fp ~/.fonts
xset fp rehash &
xset -dpms &
xset s off &
xset r rate 330 50 &
xrandr --output DP-1 --primary --mode 2560x1440 --pos 1920x0 --output DVI-I-1 --mode 1920x1080 --pos 0x0 --rotate normal
xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
sh ~/scripts/bar.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/LifeGuardPostAtBeach.jpe &
compton -b -f --fade-delta 8 -O 0.05 --shadow-opacity 0.5 --config ~/compton.conf &
sh ~/scripts/start.sh &
numlockx &
sxhkd &
exec bspwm
