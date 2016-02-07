# dotfiles
All my dotfiles that I've poured hours into. Don't get your hopes up. They're still terrible

## Info
This setup expects you to use ```startx``` upon boot as this setup does not use a display manager.

So this setup consists of a lot of parts. The important ones are
* bspwm (and sxhkd)
* kryptn-bar/lemonbar-xft
* urxvt

I use a lot of other things to achieve what I want in those programs (aesthetically and functionally). Here's a list of what I use
* alsa-utils for volume and xorg-xbacklight for info on bar
* dunst for notifications
* compton for shadows and fading mostly but also transparency
* FontAwesome and Hermit as my fonts
* rofi as my launcher

## Screenshots
Note: I intend to change the wallpaper at some point. I think it's ok but doesn't quite suit the setup quite right.
Only single monitor pics for now. I'll update with dual monitor pics at a later point in time (very soon^tm :) ).
![Setup 8](https://u.teknik.io/mVheP.png)
![Setup 9](https://u.teknik.io/N5bll.png)
![Setup 10](https://u.teknik.io/Skyoz.png)
![Setup 11](https://u.teknik.io/hwNVv.png)
![Setup 12](https://u.teknik.io/cxzqn.png)

## Contents
* A setup script you can run that will install all the packages you need and optionally some of the applications I use on a day to day basis (restore-setup-arch1.sh)
* A second setup script that installs all the files from this repo (restore-setup-arch2.sh)
* The fonts I use. Only here to make installation quicker (I did not make them, duh. Credits to Dave Gandy for FontAwesome and GitHub user "pcaro90" for Hermit).
* All my dotfiles and bar script (.Xresources, .vimrc, .xinitrc, dunstrc, compton.conf, etc.)
* Color test scripts (colortest.sh, rupee.sh, pipes.sh)
* Some randy scripts that I use. updatedotgit.sh is used for comparing files of the same name in 2 separate, user specified locations. Useful for making sure my dotfiles are all the latest before I push them. lock.sh for locking my system.

## Bugs/To Be Fixed
* Monitor support for the bar may or may not work currently. I'll test it when I can, but for now I think it works, I'm just not sure.
* Volume works on some systems but will you will most likely have to edit sxhkdrc and lbarout.sh/lbarout2.sh to get those to work properly
* Wallpaper is good/10. I want it to be better.
