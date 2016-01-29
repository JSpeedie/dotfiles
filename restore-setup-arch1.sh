# Installs everything needed for this setup which is, primarily, bspwm + sxhkd but also all the things I use like
# urxvt, xrandr, firefox, alsamixer, screenfetch, xinit, etc.

PKGLIST=(bspwm sxhkd conky rofi feh rxvt-unicode xorg-xinit dunst libnotify vim i3lock)
OPKGLIST=(xorg-xrandr firefox alsa-utils scrot screenfetch flashplugin unzip)
YPKGLIST=(compton lemonbar-xft-git)

cd ~
clear
echo " ╔════════════════════════════════════════════════╗ "
echo " ║                  SETUP SCRIPT                  ║ "
echo " ╚════════════════════════════════════════════════╝ "
echo "                   Distro: Arch"
echo "                    Shell: bash"
echo "                       WM: bspwm"
echo "                Panel/Bar: lemonbar-xft-git"
echo "                 Launcher: rofi"
echo "                     Font: Hermit"
echo "            Notifications: dunst"
echo "               Compositor: compton"
echo
for i in $(printf "PKGLIST\nOPKGLIST\nYPKGLIST"); do
	if [[ $i == "PKGLIST" ]]; then
		CPKGL=("${PKGLIST[@]}")
	elif [[ $i == "OPKGLIST" ]]; then
		CPKGL=("${OPKGLIST[@]}")
	elif [[ $i == "YPKGLIST" ]]; then
		CPKGL=("${YPKGLIST[@]}")
	else
		CPKGL=("${PKGLIST[@]}")
	fi
	echo
	echo "Packages: (${CPKGL[*]})"
	echo "Type any non-number/whitespace character(s) to exit"
	printf "Enter n° of packages to be installed (ex: 1 2 3) (enter=all) "
	read -a INPUT
	if [[ ${INPUT[*]} == "" ]]; then
		printf "Ask for confirmation for each package? [Y/n] "
		read ANS
		for j in ${CPKGL[*]}; do
			if [[ $ANS == "Y" ]]; then
				sudo pacman -S $j
			elif [[ $ANS == "n" ]]; then
				sudo pacman -S $j --noconfirm
			else
				echo "Incorrect input. Exiting..."
				exit 1
			fi
		done
	elif [[ ${INPUT[*]} =~ ^([0-9]{1,}[ \t]*){1,}$ ]]; then
		printf "Ask for confirmation for each package? [Y/n] "
		read ANS
		# manipulate input to get the numbers they wanna install.
		# for loop through those numbers and install each package
		for j in ${INPUT[*]}; do
			if [[ $ANS == "Y" ]];
			then
				sudo pacman -S ${CPKGL[j-1]}
			elif [[ $ANS == "n" ]];	then
				sudo pacman -S ${CPKGL[j-1]} --noconfirm
			else
				echo "Incorrect input. Exiting..."
				exit 1
			fi
		done
	else
		echo "Incorrect input. Exiting..."
		exit 1
	fi
done
