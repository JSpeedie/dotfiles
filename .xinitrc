[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
sxhkd &
sh ~/.lemonbarscripts/lbarout.sh &
dunst -config ~/dunstrc &
feh --bg-scale ~/Pictures/Wallpapers/ForestAndLake.jpg &
compton -b -f -D 2 -O 0.05 --config ~/compton.conf &
exec bspwm
