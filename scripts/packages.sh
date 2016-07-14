# Installs everything needed for this setup which is, primarily,\
# bspwm + sxhkd but also all the things I use like urxvt, xrandr, firefox, \
# alsamixer, screenfetch, xinit, etc.

red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

PKGLIST=(bspwm sxhkd lm_sensors rofi feh rxvt-unicode xorg xorg-xinit \
	xorg-xrandr dunst libnotify pulseaudio pamixer mpd mpc ctags)
OPKGLIST=(firefox alsa-utils scrot screenfetch flashplugin unzip zip vim eog \
	gimp nautilus xorg-xfontsel ntfs-3g)
YPKGLIST=(compton lemonbar-xft-git)
OYPKGLIST=(google-chrome-beta google-talkplugin sublime-text)

cd ~
clear
printf "$blue"
printf " ╔════════════════════════════════════════════════╗ \n"
printf " ║                  SETUP SCRIPT                  ║ \n"
printf " ╚════════════════════════════════════════════════╝ \n"
printf "                  Script for: Arch\n"
printf "$end\n"
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
	printf "${green}Packages: (${CPKGL[*]})\n${end}"
	echo "Type any non-number/whitespace character(s) (besides \"skip\" \
		to exit"
	printf "${red}==> Enter n° of packages to be installed (ex: 1 2 3) \
		(enter=all) ${end}"
	read -a INPUT

	# If the user just hits enter
	if [[ ${INPUT[*]} == "" ]]; then
		pkg=""
		num=1
		for n in ${CPKGL[*]}; do
			pkg+="$num "
			let num+=1
		done
		echo "Packages chosen: $pkg"
	# For if the user doesn't want to install anything from the collection
	elif [[ ${INPUT[*]} == "skip" ]]; then
		echo "Skipping to next collection of packages..."
	# If the user entered a white space delimited list of numbers
	elif [[ ${INPUT[*]} =~ ^([ \t]*[0-9]{1,}[ \t]*){1,}$ ]]; then
		pkg=${INPUT[*]}
		echo "Packages chosen: $pkg"
	# The user chose to exit by input "any non-number/whitespace
	# characters (besides "skip")"
	else
		echo "Invalid input. Exiting..."
		exit 1
	fi

	printf "Ask for confirmation for each package? [Y/n] (enter=n) "
	read ANS

	for j in $pkg; do
		if [[ $ANS == "Y" ]]; then
			if [[ $i == "YPKGLIST" ]] || [[ $i == "OYPKGLIST" ]]; then
				yaourt ${CPKGL[j-1]}
			else
				sudo pacman -S ${CPKGL[j-1]}
			fi
		elif [[ $ANS == "n" or $ANS == "" ]]; then
			if [[ $i == "YPKGLIST" ]] || [[ $i == "OYPKGLIST" ]]; then
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

# Configure git stuff (tba)
