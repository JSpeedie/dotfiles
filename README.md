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
* compton for shadows mostly but also transparency
* FontAwesome and Hermit
* rofi as my launcher

## Screenshots
Note: these are slightly outdated. Rofi, my bash prompt, my bar (slightly) and some small compton.conf changes have occurred since these were taken, but there's not a huge difference.
Only single monitor pics for now. I'll update with dual monitor pics at a later point in time.
![Setup 4](https://u.teknik.io/W3hEGT.png)
![Setup 5](https://u.teknik.io/nJXHFl.png)
![Setup 5.5](https://u.teknik.io/IZdl0Q.png)
![Setup 6](https://u.teknik.io/LpYdN7.png)
![Setup 7](https://u.teknik.io/RYiRlu.png)

## Contents
* A setup script you can run that will install all the packages you need and optionally some of the applications I use on a day to day basis (restore-setup-arch1.sh)
* All my dotfiles (.Xresources, .vimrc, .xinitrc, dunstrc, compton.conf, etc. Check the thing, lazy)
* Color test scripts (colortest.sh, rupee.sh, pipes.sh)

## Bugs/To Be Fixed
* Monitor support for the bar may or may not work currently. I'll test it when I can, but for now I think it works, I'm just not sure.
* Volume works on some systems but will you will most likely have to edit sxhkdrc and lbarout.sh/lbarout2.sh to get those to work properly
