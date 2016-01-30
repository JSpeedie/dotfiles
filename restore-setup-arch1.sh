# Installs everything needed for this setup which is, primarily, bspwm + sxhkd but also all the things I use like
# urxvt, xrandr, firefox, alsamixer, screenfetch, xinit, etc.

PKGLIST=(bspwm sxhkd conky rofi feh rxvt-unicode xorg-xinit dunst libnotify vim i3lock)
OPKGLIST=(xorg-xrandr firefox alsa-utils scrot screenfetch flashplugin unzip)
YPKGLIST=(compton lemonbar-xft-git)
OYPKGLIST=(google-chrome)

cd ~
clear
echo " ╔════════════════════════════════════════════════╗ "
echo " ║                  SETUP SCRIPT                  ║ "
echo " ╚════════════════════════════════════════════════╝ "
echo "                   Distro: Arch"
echo "                    Shell: bash"
echo "                       WM: bspwm"
echo "                Panel/Bar: lemonbar-xft-git"
echo "        Terminal Emulator: urxvt"
echo "                 Launcher: rofi"
echo "                     Font: Hermit"
echo "            Notifications: dunst"
echo "               Compositor: compton"
echo
for i in $(printf "PKGLIST\nOPKGLIST\nYPKGLIST\nOYPKGLIST"); do
	if [[ $i == "PKGLIST" ]]; then
		CPKGL=("${PKGLIST[@]}")
	elif [[ $i == "OPKGLIST" ]]; then
		CPKGL=("${OPKGLIST[@]}")
	elif [[ $i == "YPKGLIST" ]]; then
		CPKGL=("${YPKGLIST[@]}")
	elif [[ $i == "OYPKGLIST" ]]; then
		CPKGL=("${OYPKGLIST[@]}")
	else
		CPKGL=("${PKGLIST[@]}")
	fi
	echo
	echo "Packages: (${CPKGL[*]})"
	echo "Type any non-number/whitespace character(s) to exit"
	printf "Enter n° of packages to be installed (ex: 1 2 3) (enter=all) "
	read -a INPUT
	if [[ ${INPUT[*]} == "" ]]; then
		pkg=""
		num=1
		for n in ${CPKGL[*]}; do
			pkg+="$num "
			let num+=1
		done
		echo "Packages chosen: $pkg"
	elif [[ ${INPUT[*]} =~ ^([ \t]*[0-9]{1,}[ \t]*){1,}$ ]]; then
		pkg=${INPUT[*]}
		echo "Packages chosen: $pkg"
	else
		echo "Invalid input. Exiting..."
		exit 1
	fi
	printf "Ask for confirmation for each package? [Y/n] "
	read ANS
	for j in $pkg; do
		if [[ $ANS == "Y" ]]; then
			if [[ $i == "YPKGLIST" ]]; then
				yaourt ${CPKGL[j-1]}
			else
				sudo pacman -S ${CPKGL[j-1]}
			fi
		elif [[ $ANS == "n" ]]; then
			if [[ $i == "YPKGLIST" ]]; then
				yaourt ${CPKGL[j-1]} --noconfirm
			else
				sudo pacman -S ${CPKGL[j-1]} --noconfirm
			fi
		else
			echo "Invalid input. Exiting..."
			exit 1
		fi
	done
done
