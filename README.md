## Info
This setup expects you to use `startx` upon boot as it does not use a
display manager.

The important parts of this setup are:
* bspwm (and sxhkd) as my wm (for now...)
* kryptn-bar/lemonbar-xft as my bar
* urxvt as my terminal emulator

I use a couple of other, less important things to achieve what I want in my
setup (A E S T H E T I Cally and functionally). Here's some of them:
* `pulseaudio`, `pamixer`, and `xorg-xbacklight` for volume and brightness
info on the bar.
* `dunst` for notifications.
* `compton` for shadows, fading and transparency.
* Siji as my icon font and Tamzen as my normal-text-font.
* `rofi` as my launcher.
* `vim` as my text editor

## Screenshots

So I decided to update these pictures cause it was getting out of hand. It
needed to be updated and I'm just taking way too long on my switch to wmutils
so here ya go.
First one is a reorganized version of the second one which is what my setup
is actually like. I included the first pic just because I thought it would be
easier to view and make it easier to see the whole rice.

* [Reorganized for easier viewing](https://u.teknik.io/Ph1Ct.png)
* [Pure](https://u.teknik.io/hfLPB.png)

## Feature list

bar.sh:
* Few dependencies (rip). Bar requires 5 packages (`lm_sensors` for cpu temp,
`pulseaudio` + `pamixer` for the volume, `mpd` and `mpc` for `song()`).
* `net()` tells you whether you have a connection regardless of what network
interface you're using. It does this by pinging your default gateway which
means it will be always be accurate (unlike a script that pings some
randy website).
* Battery and volume icons change based on the amount of battery left/the volume.
* Scrolling text for `song()` (requires `scrolltext2.sh`)

sxhkdrc:
* Logical shortcut for locking (alt + escape, similar to alt + super + escape
for exiting the bspwm session).
* Binds for decreasing/increasing volume and brightness (alt + n/m and alt +
shift + n/m respectively).
* Binds for controlling mpd through mpc (insert song to playlist (alt + i),
toggle pause/play (alt + l), prev/next (alt + u/o))

.vimrc:
* Short and sweet. Doesn't rely on 6 million plugins (which I understand some
of you may dislike, but I personally prefer to not rely on too many thing
in case I have to use someone elses' setup or `vi`).
* Sets the history to 1000, enables syntax highlighting, enables folding
via markers ("{{{" and "}}}" by default), shows relative line numbers
to make j and k movements easier.
* Some regexes I would consider impressive if only because they are hard
to understand. Highlights trailing whitespace red for easy removal and gray
if it's escaped (only highlights the first whitespace character, not the rest
of the line if the last non-whitespace character was "\"). Gray because it's
easy to see, but not in your face.
* Here come dat statusline! No plugins here. Fairly simple statusline with a
modified version of the `%m` modified flag
* Well commented for your line-stealing needs.

updatedir.sh
* Probably my favourite and most used script. Compares the contents of two
directories and for each file asks if you want to copy, do nothing, compare,
or revert (copy in opposite direction) the files in the first
to the second. It can take a filter (a bash command located in a file which is
specified when you call `updatedir.sh`. This script is very useful for
updating say, a dotfile directory from your home directory.

install.sh
* When executed within a git directory or git sub directory (and so on and
so forth), it will copy all the files tracked by git
into `~/individual_file_path`. Used for getting my setup on a fresh install
quickly.

packages.sh:
* Separates between the packages required for this setup and those I like to
use. Even further it separates between non-AUR and AUR packages.
* Run it and get prompted with various questions resulting in a version of
my setup tailored to you. ^(lol)
* Short and simple, with the package lists at the top of the script in case
you want to change this script and make it your own.

.bashrc:  
![Webm of my sick ass prompt I worked so hard on](https://raw.githubusercontent.com/wiki/JSpeedie/dotfiles/images/bashprompt.gif)
* My god. This was hard, ok. Just look at the code. It's horrendous. I'll most
likely fix that in the future but for now... it works. Thank god.
* Coloured prompt to make it more clear where one command's output ends and
another command begins.
* This next part is what was so hard to do. The `$` changes to red if the
previously run command errors. For those interested, the reason this was so
hard to achieve is because bash doesn't play nicely with non-printing
characters. So using `tput` causes weird issues that I noticed and reported
as #3. You have to wrap those commands with `\[` and `\]` but you can't use
those with `' '` which are necessary to make sure changes are made to your
prompt every time you hit enter (colour change, current directory). Luckily
you can use `\001` and `\002` as replacements with the small downside that
you have to add either ` -e` to your `echo` call or use `printf`.
* Side note: Yes this prompt is heavily based off of the one done by reddit
user /u/tudurom, however they did not have a solution to #3. Seeing as I had
to work so hard to get the functionality, I'll claim this prompt as my own,
but I give full credit to them for inspiration.

playsong.sh:
* Script I'm some what proud of. Prompts user with a list of all the songs
they have in their mpd music directory and (using rofi)
allows them to select one to play next.

colortest.sh, rupee.sh, pipes.sh:
* All of these except colortest.sh weren't made by me. colortest.sh is a
simple script that prints out the 16 colours of your terminal in order.
Semi useful. rupee.sh comes from reddit account /u/roberoonska and pipes.sh
from github user pipeseroni.

.Xresources
* Nothing special. Colours rofi to match my colours theme and colours urxvt
but I mean that's about it :/

## Contents
* The sickest bash prompt you will ever see in your life.
* A setup script you can run that will install all the packages you need and
optionally some of the applications I use on a day to day basis (`packages.sh`)
* A second setup script that installs all the files from this repo (`install.sh`)
* ~~The fonts I use. Only here to make installation quicker (I did not make
them, duh. Credits to Dave Gandy for FontAwesome and GitHub user "pcaro90"
for Hermit).~~
* All my dotfiles and bar script (`.Xresources`, `.vimrc`, `.xinitrc`,
`dunstrc`, `compton.conf`, etc.)
* Color test scripts (`colortest.sh`, `rupee.sh`, `pipes.sh`)
* Some randy scripts that I use. `updatedir.sh` for updating dotfiles repo,
`lock.sh` for locking my system, etc.

## Bugs/To Be Fixed
* #3 ~~.bashrc prompt becomes a mess of characters from previous commands if
you press up or down enough~~ Believed to be solved in commit 3244c7c
* alt + *x* keybindings conflict with bindings of applications (will most
likely be swapped to super + *x* in the future)
