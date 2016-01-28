# Installs everything needed for this setup which is, primarily, bspwm + sxhkd but also all the things I use like
# urxvt, xrandr, firefox, alsamixer, screenfetch, xinit, etc.

PKGLIST=(bspwm sxhkd conky rofi feh rxvt-unicode xorg-xinit dunst libnotify i3lock)
OPKGLIST=(xorg-xrandr firefox alsa-utils scrot screenfetch flashplugin unzip)

cd ~
clear
printf "========================================\n"
printf "=             SETUP SCRIPT             =\n"
printf "========================================\n"
printf "Distro: Arch\nShell: bash\nSetup:\n\tWM: bspwm\n\tPanel/Bar: kryptn-bar/lemonbar-xft\n\tLauncher: rofi\n\tFont: Hermit\n"
echo
echo "Packages: (${PKGLIST[*]})"
printf "Choose packages to install (default=all): "
read -a LIST
if [[ ${LIST[*]} == "" ]];
then
	printf "Ask for confirmation for each package? [Y/n] "
	read ANS
	if [[ $ANS == "Y" ]];
	then
		for i in ${PKGLIST[*]};
		do
			sudo pacman -S $i
		done
	elif [[ $ANS == "n" ]];
	then
		for i in ${PKGLIST[*]};
		do
			sudo pacman -S $i --noconfirm
		done
	else
		echo "Incorrect input. Exiting..."
	fi
elif [[ ${LIST[*]} =~ ^([0-9]{1,}[ \t]*){1,}$ ]];
then
	printf "Ask for confirmation for each package? [Y/n] "
	read ANS
	if [[ $ANS == "Y" ]];
		then
		# manipulate string to get the numbers you wanna install
		# for loop through those numbers and install each one
		for i in ${LIST[*]};
		do
			sudo pacman -S ${PKGLIST[$i]}
		done
	elif [[ $ANS == "n" ]];
	then
		# manipulate string to get the numbers you wanna install
		# for loop through those numbers and install each one
		for i in ${LIST[*]};
		do
			sudo pacman -S ${PKGLIST[$i]} --noconfirm
		done
	else
		echo "Incorrect input. Exiting..."
	fi
else
	echo "Incorrect input. Exiting..."
fi

#
# Install optional packages (mostly just for me when I reinstall arch)
#

echo "Packages: (${OPKGLIST[*]})"
echo "Enter any non number/digit if you don't want to install the optonal packages (ex. \"n\")"
printf "Choose optional packages to install (default=all): "
read -a LIST
if [[ ${LIST[*]} == "" ]];
then
	printf "Ask for confirmation for each package? [Y/n] "
	read ANS
	if [[ $ANS == "Y" ]];
	then
		for i in ${OPKGLIST[*]};
		do
			sudo pacman -S $i
		done
	elif [[ $ANS == "n" ]];
	then
		for i in ${OPKGLIST[*]};
		do
			sudo pacman -S $i --noconfirm
		done
	else
		echo "Incorrect input. Exiting..."
	fi
elif [[ ${LIST[*]} =~ ^([0-9]{1,}[ \t]*){1,}$ ]];
then
	printf "Ask for confirmation for each package? [Y/n] "
	read ANS
	if [[ $ANS == "Y" ]];
		then
		# manipulate string to get the numbers you wanna install
		# for loop through those numbers and install each one
		for i in ${LIST[*]};
		do
			sudo pacman -S ${OPKGLIST[$i]}
		done
	elif [[ $ANS == "n" ]];
	then
		# manipulate string to get the numbers you wanna install
		# for loop through those numbers and install each one
		for i in ${LIST[*]};
		do
			sudo pacman -S ${OPKGLIST[$i]} --noconfirm
		done
	else
		echo "Incorrect input. Exiting..."
	fi
else
	echo "Incorrect input. Exiting..."
fi
