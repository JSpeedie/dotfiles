[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
sxhkd &
sh ~/.lemonbarscripts/lbarout.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/LifeGuardPostAtBeach.jpe &
compton -b -f -D 5 -O 0.05 --config ~/compton.conf &
exec bspwm
