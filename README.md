# Table of Contents
<details><summary>Click to Expand</summary><p>

* [Purpose](#purpose)
* [Installation](#installation)
* [Screenshots](#screenshots)
* [Feature list](#feature-list)
* [Contents](#contents)
* [Bugs/To Be Fixed](#bugsto-be-fixed)
</p></details>

## Purpose

This repository contains all my configurations for my preferred Linux setup.
The purpose of the repo is to provide an easy way for me to get my preferred
working environment quickly when I am faced with a new installation or computer.
Part of this function is to provide me with and configure all my
most used tools, and the other part is to achieve the stylistic qualities I like.


## Installation

```bash
# If you want to push to the repo
git clone git@github.com:JSpeedie/dotfiles.git dotfilesGit
# If you are just installing
git clone https://www.github.com/JSpeedie/dotfiles dotfilesGit
cd dotfilesGit/scripts
sh packages.sh
sh install.sh
```

### Some unorganized notes to consider before diving into the details

<details><summary>Click to Expand</summary><p>
This setup expects you to use `startx` upon boot as it does not use a
display manager.

I use a couple of other, less important things to achieve what I want in my
setup (aesthetically and functionally). Here's some of them:
* `pulseaudio`, `pamixer`, and `xorg-xbacklight` for volume and brightness
info on the bar.
* `dunst` for notifications.
* `compton` for shadows, fading and transparency.
* Siji as my icon font and Tamzen as my normal-text-font.
* `rofi` as my launcher.
* `nvim` as my text editor
</p></details>

## Screenshots

![Screenfetch](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/Setup23PelagicSFUnconf.png)
![Fake Work](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/Setup24PelagicWork.png)
![Rofi](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/Setup25PelagicRofi.png)

## Feature list

![Picture of bar](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/bar.png)  
*scripts/bar.sh*:
* This bar requires 5 packages (`lm_sensors` for cpu temp, `pulseaudio` +
`pamixer` for the volume, `mpd` and `mpc` for `song()`).
* `net()` tells you whether you have a connection regardless of what network
interface you're using. It does this by pinging your default gateway which
means it will be always be accurate (unlike a script that pings some
randy website).
* Battery and volume icons change based on the amount of battery left/the volume.
* Scrolling text for `song()` (requires `scrolltext2.sh`)

![Gif of vim setup](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/vim.gif)  
*.vimrc*:
* Short and sweet. Doesn't rely on a million plugins (I personally prefer to
not rely on too many in case I have to use someone elses' setup or `vi`).
* Sets the history to 1000, enables syntax highlighting, enables folding
via markers ("{{{" and "}}}" by default), shows relative line numbers
to make j and k movements easier.
* Some regexes I would consider impressive if only because it took me quite
  some time to come to to understand them. Highlights trailing whitespace red
  for easy removal and gray if it's escaped (only highlights the first escaped
  whitespace character).
* Here come dat statusline! No plugins here. Fairly simple statusline with a
  modified version of the `%m` modified flag
* Well commented for your line-stealing needs.

![Gif of my sick prompt I worked so hard on](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/bashprompt.gif)  
*.bashrc:*
* Coloured prompt to make it more clear where one command's output ends and
another command begins.
* What made this so difficult was getting the `•` to change colours upon
a successfully run command or red on an unsuccessfully run command. For those
interested, the reason this was so hard to achieve is because bash doesn't
play nicely with non-printing characters which are how it sets the colour.
This caused weird issues that I noticed and reported as issue #3. The solution
is wrapping the code that checks for the return status of the previous command
and sets the colour accordingly with `\[` and `\]`. However, you can't use those
with `' '` which are necessary to make sure changes are made to your
prompt every time you hit enter (like having the colours change, or current
directory). Luckily you can use `\001` and `\002` as replacements with the
small downside that you have to add either ` -e` to your `echo` call or use
`printf`.

*scripts/updatedir.sh:*
* One of my most used scripts. Compares the contents of two
directories and for each file asks if you want to copy, do nothing, compare,
or revert (copy in opposite direction) the files in the first
to the second. It can take a filter (a bash command located in a file which is
specified when you call `updatedir.sh`. This script is very useful for
updating say, a dotfile directory from your home directory.

*scripts/install.sh:*
* When executed within a git directory or git sub directory (and so on and
so forth), it will copy all the files tracked by git
into `~/individual_file_path`. Used for getting my setup on a fresh install
quickly.

*scripts/packages.sh:*
* Separates between the packages required for this setup and those I like to
use. Even further it separates between non-AUR and AUR packages.
* Run it and get prompted with various questions resulting in a version of
my setup tailored to you. <sup>lol</sup>
* Short and simple, with the package lists at the top of the script in case
you want to make it your own.

*.config/sxhkd/sxhkdrc*:
* Logical shortcut for locking (alt + escape, similar to alt + super + escape
for exiting the bspwm session).
* Binds for decreasing/increasing volume and brightness (alt + n/m and alt +
shift + n/m respectively).
* Binds for controlling mpd through mpc (insert song to playlist (alt + i),
toggle pause/play (alt + l), prev/next (alt + u/o))

*scripts/playsong.sh:*
* Script I'm fairly happy with. Prompts user with a list of all the songs
they have in their mpd music directory and (using `rofi`)
allows them to select one to play next.

*scripts/colortest.sh, scripts/rupee.sh, scripts/pipes.sh:*
* All of these except colortest.sh weren't made by me. colortest.sh is a
simple script that prints out the 16 colours of your terminal in order.
Semi useful. rupee.sh comes from reddit account /u/roberoonska and pipes.sh
from github user pipeseroni.

*.Xresources:*
* Nothing special. Colours rofi to match my colours theme and colours urxvt
but I mean that's about it :/

## Contents
* A very simple responsive prompt
* A setup script you can run that will install all the packages you need and
optionally some of the applications I use on a day to day basis (`packages.sh`)
* A second setup script that installs (read: copies them to the correct
directory) all the files from this repo (`install.sh`)
* ~~The fonts I use. Only here to make installation quicker (I did not make
them, duh. Credits to Dave Gandy for FontAwesome and GitHub user "pcaro90"
for Hermit).~~
* All my dotfiles and bar script (`.Xresources`, `.vimrc`, `.xinitrc`,
`dunstrc`, `compton.conf`, etc.)
* Color test scripts (`colortest.sh`, `rupee.sh`, `pipes.sh`)
* Some miscellaneous scripts that I use. `updatedir.sh` for updating dotfiles repo,
`lock.sh` for locking my system, etc.

## Bugs/To Be Fixed
* Gifs need to be updated
* `lock.sh` status currently unknown.
* Add locking gif
* #3 ~~.bashrc prompt becomes a mess of characters from previous commands if
you press up or down enough~~ Believed to be solved in commit 3244c7c
* alt + *x* keybindings conflict with bindings of applications (will most
likely be swapped to super + *x* in the future)
