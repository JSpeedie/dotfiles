## Info
This setup expects you to use ```startx``` upon boot as this it does not use a display manager.

The important parts of this setup are:
* bspwm (and sxhkd) as my wm
* kryptn-bar/lemonbar-xft as my bar
* urxvt as my terminal emulator

I use a couple of other, less important things to achieve what I want in my setup (aesthetically and functionally). Here's a list of what I use:
* alsa-utils and xorg-xbacklight for volume and brightness info on the bar.
* dunst for notifications.
* compton for shadows, fading and transparency.
* FontAwesome and Hermit as my fonts.
* rofi as my launcher.
* vim as my text editor

## Screenshots

![Setup 16](https://u.teknik.io/PlzVk.png)
![Setup 17](https://u.teknik.io/Qf4sF.png)
![Setup 18](https://u.teknik.io/UGyGW.png)

## Feature list

The bar:
* Few dependencies. Bar requires only one other package (lm_sensors for cpu temp).
* NetUp() tells you whether you have a connection regardless of what network interface you're using. It does this by pinging your default gateway which means it will be always be accurate (unlike a script that pings some randy website).
* Workspace icons will take you to that workspace if clicked.
* Battery and volume icons change based on the amount of battery left/the volume.
* Automatically creates one instance of the bar per monitor in your setup.

sxhkdrc:
* Logical shortcut for locking (alt + escape, similar to alt + super + escape for exiting the bspwm session).
* Binds for decreasing/increasing volume and brightness (alt + n/m and alt + shift + n/m respectively).
* Binds for making windows sticky, locked or private (super + z, super + x,  super + v).
* Bind for minimizing all windows (super + d).
* Binds for decreasing/increasing padding size on the fly (alt + minus/equal).

bspwmrc:
* Automatically assigns desktops (workspaces), evenly to all of your monitors. Really nice when you're using this setup on multiple setups with varying amounts of screens. It creates floor(10/monitors) desktops per monitor. 10 because 10 desktops works nicely with binds (super + 1-0).
* Colours for locked, stickied and private windows.

.vimrc:
* Short and sweet. Doesn't rely on 6 million plugins (which I understand some of you may dislike, but I personally prefer to not rely on too many thing in case I have to use someone elses setup or vi for some reason).
* Sets the history to 1000, enables syntax highlighting, enables folding via markers ("{{{" and "}}}" by default), shows relative line numbers to make indenting or deleting a number of lines easier.

packages.sh:
* Separates between the packages required for this setup and those I like to use. Even further it separates between non-AUR and AUR packages.
* Run it and get prompted with various questions resulting in my setup tailored to you.
* Short and simple, with the package lists at the top of the script in case you want to change this script and make it your own.

.bashrc:
* Coloured and simple prompt to make it more clear where one command ends and another one begins.

lock.sh:
* Blurs the background and locks the system with a picture of a lock.
* Looks pretty cool k.

colortest.sh, rupee.sh, pipes.sh:
* None of these were made by me so credit where it's due. colortest.sh was taken from http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html. rupee.sh comes from reddit account /u/roberoonska and pipes.sh from github user pipeseroni.

.Xresources
* Nothing special. Colours rofi to match my colours theme and colours urxvt but I mean that's about it :/

## Contents
* A setup script you can run that will install all the packages you need and optionally some of the applications I use on a day to day basis (packages.sh)
* A second setup script that installs all the files from this repo (install.sh)
* The fonts I use. Only here to make installation quicker (I did not make them, duh. Credits to Dave Gandy for FontAwesome and GitHub user "pcaro90" for Hermit).
* All my dotfiles and bar script (.Xresources, .vimrc, .xinitrc, dunstrc, compton.conf, etc.)
* Color test scripts (colortest.sh, rupee.sh, pipes.sh)
* Some randy scripts that I use. updatedotgit.sh is used for comparing files of the same name in 2 separate, user specified locations. Useful for making sure my dotfiles are all the latest before I push them. lock.sh for locking my system.

## Bugs/To Be Fixed
* Volume works on some systems but will you will most likely have to edit sxhkdrc and lbarout.sh to get those to work properly
