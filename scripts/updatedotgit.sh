#!/bin/bash

First=(~/)
Second=(~/dotfilesGit/)

red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

# Files that need to be updated
# FLIST=(.config/bspwm/bspwmrc .config/sxhkd/sxhkdrc .lemonbarscripts/lbarout.sh .Xresources .bash_profile .bashrc .gtkrc-2.0\
# .profile .vimrc .xinitrc compton.conf dunstrc restore-setup-arch1.sh install.sh updatedotgit.sh .vim/colors/gruvbox.vim\
# .vim/colors/ryuuko.vim Pictures/Wallpapers/solid.jpg Pictures/Wallpapers/LifeGuardPostAtBeach.jpe coloursconf)
FLIST=($(cd $Second; git ls-tree -r master --name-only | grep -v "\(hermit\)\|\(font-awesome\)\|\(README.md\)")) 

printf "File path for first spot (default=$First) "
read FirstRead
if [[ $FirstRead != "" ]]; then
	First=$FirstRead; fi

printf "File path for second spot (default=$Second) "
read SecondRead
if [[ $SecondRead != "" ]]; then
	Second=$SecondRead; fi

printf "Only list files that differ from their counterparts? [Y/n] "
read LISTIF
echo
if [[ $LISTIF != "Y" ]] && [[ $LISTIF != "n" ]] && [[ $LISTIF != "" ]]; then
	echo "Invalid input. Exiting..."
	exit 1
fi

for file in ${FLIST[@]}; do
	if [[ -d $First$file ]]; then
		continue
	fi

	difftest=$(cmp -s $First$file $Second$file; echo $?)
	if [[ $LISTIF == "Y" ]] || [[ $LISTIF == "" ]]; then
		# If the files aren't different, continue.
		if [[ $difftest == "0" ]]; then continue; fi
	fi
	# Print if the files differ or not
	if [[ $difftest != "0" ]]; then
		echo "$red==> The files differ$end"
	else
		echo "$green==> The files do NOT differ$end"
	fi

	echo "Y=Yes, n=no, c=compare"
	printf "Update $file? [Y/n/c] "
	read ANS
	if [[ $ANS == "Y" ]] || [[ $ANS == "" ]]; then cp -v $First$file $Second$file;
	elif [[ $ANS == "n" ]]; then echo "Continuing to next file...";
	elif [[ $ANS == "c" ]]; then vimdiff $First$file $Second$file;
	else echo "Invalid input. Exiting..."; exit 1; fi

	echo ""
done
echo "Done!"
