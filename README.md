# dotfiles
All my dotfiles that I've poured hours into. Don't get your hopes up. They're still terrible ;)

Info
----
So this setup consists of a lot of parts. The important ones are
* bspwm (and sxhkd)
* kryptn-bar/lemonbar-xft
* urxvt

I use a lot of other things to achieve what I want in those programs (aesthetically and functionally). Here's a list of what I use
* conky for some of my bar info
* dunst for notifications
* compton for shadows mostly but also transparency
* FontAwesome and Hermit
* rofi as my launcher

Screenshots
-----------
Only single monitor pics for now. I'll update with dual monitor pics at a later point in time
![Setup 4](https://u.teknik.io/W3hEGT.png)
![Setup 5](https://u.teknik.io/nJXHFl.png)
![Setup 5.5](https://u.teknik.io/IZdl0Q.png)
![Setup 6](https://u.teknik.io/LpYdN7.png)
![Setup 7](https://u.teknik.io/RYiRlu.png)

Contents
--------
* A setup script you can run that will install all the packages you need and optionally some of the applications I use on a day to day basis (restore-setup-arch1.sh)
* All my dotfiles (.Xresources, .vimrc, .xinitrc, dunstrc, .conkyrc, compton.conf, etc. Check the thing, lazy)
* A color test script (colortest.sh)

Bugs/To Be Fixed
----------------
* Monitor support is absolutely terrible unless you have have the exact same setups as me. You will have to edit my bspwmrc and lbarout.sh/lbarout2.sh to get everything setup right.
* Volume works on some systems but will you will most likely have to edit sxhkdrc and lbarout.sh/lbarout2.sh to get those to work properly
* Rofi currently fairly transparent. One day when i feel motivated enough, I'll look into fixing that. Rn you can just not run compton and it won't be a problem.
