## Info
This setup expects you to use ```startx``` upon boot as this it does not use a display manager.

The important parts of this setup are:
* bspwm (and sxhkd) as my wm (for now...)
* kryptn-bar/lemonbar-xft as my bar
* urxvt as my terminal emulator

I use a couple of other, less important things to achieve what I want in my setup (A E S T H E T I Cally and functionally). Here's a list of what I use:
* pulseaudio, pamixer, and xorg-xbacklight for volume and brightness info on the bar.
* dunst for notifications.
* compton for shadows, fading and transparency.
* Siji as my icon font and Tamzen as my normal-text-font.
* rofi as my launcher.
* vim as my text editor

## Screenshots

So I decided to update these pictures cause it was getting out of hand. It needed to be updated and I'm just taking way too long on my switch to wmutils so here ya go.
First one is a reorganized version of the second one which is what my setup is actually like. I included the first pic just because I thought it would be easier to view and make it easier to see the whole rice.

* [Reorganized for easier viewing](https://u.teknik.io/Ph1Ct.png)
* [Pure](https://u.teknik.io/hfLPB.png)

## Feature list

The bar:
* Few dependencies (rip). Bar requires 3 packages (lm_sensors for cpu temp and pulseaudio + pamixer for the volume).
* NetUp() tells you whether you have a connection regardless of what network interface you're using. It does this by pinging your default gateway which means it will be always be accurate (unlike a script that pings some randy website).
* Workspace icons will take you to that workspace if clicked.
* Battery and volume icons change based on the amount of battery left/the volume.
* Automatically creates one instance of the bar per monitor in your setup.

sxhkdrc:
* Logical shortcut for locking (alt + escape, similar to alt + super + escape for exiting the bspwm session).
* Binds for decreasing/increasing volume and brightness (alt + n/m and alt + shift + n/m respectively).

.vimrc:
* Short and sweet. Doesn't rely on 6 million plugins (which I understand some of you may dislike, but I personally prefer to not rely on too many thing in case I have to use someone elses setup or vi).
* Sets the history to 1000, enables syntax highlighting, enables folding via markers ("{{{" and "}}}" by default), shows non-relative line numbers to make... something... easier.
* Some regexes I would consider impressive if only because they are hard to understand. Highlights trailing whitespace red (doesn't work atm) for easy removal and gray if it's escaped (only highlights the first whitespace character, not the rest of the line if the last non-whitespace character was "\"). Easy to see, but not in your face.
* Here come dat statusline! No plugins here. Fairly simple plugin with an improved version of the '%m' modified flag
* Well commented for your line-stealing needs.

packages.sh:
* Separates between the packages required for this setup and those I like to use. Even further it separates between non-AUR and AUR packages.
* Run it and get prompted with various questions resulting in a version of my setup tailored to you. ^(lol)
* Short and simple, with the package lists at the top of the script in case you want to change this script and make it your own.

.bashrc:
![CoolPrompt](https://u.teknik.io/FybF2.webm)
* My god. This was hard, ok. Just look at the code. It's horrendous. I'll most likely fix that in the future but for now... it works. Thank god.
* Coloured prompt to make it more clear where one command's output ends and another command begins.
* This next part is what was so hard to do. The ```$``` changes to red if the previously run command errors. For those interested, the reason this was so hard to achieve is because bash doesn't play nicely with non-printing characters. So using ```tput``` causes weird issues that I noticed and reported as #3. You have to wrap those commands with ```\[``` and ```\]``` but you can't use those with ```' '``` which are necessary to make sure changes are made to your prompt (colour change, current directory). Luckily you can use ```\001``` and ```\002``` as replacements with the small downside that you have to add either these 3 characters to your echo call (``` -e```) or use printf.

lock.sh:
* ~~Blurs the background and locks the system with a picture of a lock.~~
* ~~Looks pretty cool k.~~
* Needs to be fixed. Wanna switch to my fork of sflock at some point, but until that is more finished...

colortest.sh, rupee.sh, pipes.sh:
* All of these except colortest.sh weren't made by me. colortest.sh is a simple script that prints out the 16 colours of your terminal in order. Semi useful. rupee.sh comes from reddit account /u/roberoonska and pipes.sh from github user pipeseroni.

.Xresources
* Nothing special. Colours rofi to match my colours theme and colours urxvt but I mean that's about it :/

## Contents
* The sickest bash prompt you will ever see in your life.
* A setup script you can run that will install all the packages you need and optionally some of the applications I use on a day to day basis (packages.sh)
* A second setup script that installs all the files from this repo (install.sh)
* ~~The fonts I use. Only here to make installation quicker (I did not make them, duh. Credits to Dave Gandy for FontAwesome and GitHub user "pcaro90" for Hermit).~~
* All my dotfiles and bar script (.Xresources, .vimrc, .xinitrc, dunstrc, compton.conf, etc.)
* Color test scripts (colortest.sh, rupee.sh, pipes.sh)
* Some randy scripts that I use. updatedotgit.sh is used for comparing files of the same name in 2 separate, user specified locations. Useful for making sure my dotfiles are all the latest before I push them. lock.sh for locking my system.

## Bugs/To Be Fixed
* ~~Volume works on some systems but will you will most likely have to edit sxhkdrc and lbarout.sh to get those to work properly~~ Fixed with implementation of pulseaudio and pamixer
* #3 ~~.bashrc prompt becomes a mess of characters from previous commands if you press up or down enough~~ Believed to be solved in commit 3244c7c
* Bar script causes mouse movement stuttering
* .vimrc regex for match an Error for unescaped trailing whitespace currently does nothing
