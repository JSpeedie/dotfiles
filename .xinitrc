[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
sxhkd &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/solid.jpg
compton -b --config ~/compton.conf
exec bspwm
