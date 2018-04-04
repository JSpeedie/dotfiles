$HOME/.monicarc   #monitor calibration
xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
xset +fp ~/.fonts/tamzen-font/bdf
xset +fp /usr/share/fonts/local/
xset +fp ~/.fonts
xset fp rehash &
xset -dpms &
xset s off &
xset r rate 330 50 &
$(sh ~/scripts/getxrandr.sh)
xinput --set-prop 'Kingsis Peripherals ZOWIE Gaming mouse' 'Device Accel Constant Deceleration' 1.5 &
sh ~/scripts/bar.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/ForestFromAbove.png &
compton -b -f --fade-delta 2 -O 0.05 --shadow-opacity 0.5 --config ~/compton.conf &
sh ~/scripts/start.sh &
[ ! -s ~/.config/mpd/pid ] && mpd ~/.config/mpd/mpd.conf
numlockx &
sxhkd &
exec bspwm
