[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
xset +fp /usr/share/fonts/bitmap
sxhkd &
sh ~/.lemonbarscripts/lbarout.sh
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/solid.jpg
compton -b --config ~/compton.conf
urxvt &
exec bspwm
