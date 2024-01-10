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

PKGLIST=(vim alsa-utils lm_sensors rofi feh rxvt-unicode xorg xorg-xinit \
	xorg-xrandr dunst libnotify pulseaudio pamixer bspwm sxhkd mpd mpc ctags \
	ttf-dejavu rsync cronie dialog wpa_supplicant arc-gtk-theme arc-icon-theme \
	xf86-video-intel pkgconfig make fakeroot jq flex bison zsh zsh-completions \
	yay neovim)
OPKGLIST=(firefox ranger nautilus scrot screenfetch flashplugin unzip zip eog \
	gimp xorg-xfontsel dosfstools mtools ntfs-3g pandoc texlive-core mtp \
	mtpfs gvfs-mtp tree openssh vlc qt4 evince audacity easytags valgrind gdb ddd \
	xterm git svn numlockx network-manager network-manager-applet stalonetray \
	xorg-xfd gnome-control-center lxappearance gst-libav pitivi ttf-droid \
	adobe-source-code-pro-fonts ttf-roboto veracrypt libreoffice-fresh \
	avidemux-qt mpv gtop cmatrix asp obs-studio figlet lolcat jre8-openjdk \
	cmake racket ghc ghc-static clang java-runtime-common \
	java-environment-common bless ntp pavucontrol sl asciiquarium unrar ghex \
	virtualbox-guest-utils autoconf automake noto-fonts python-pip npm)
YPKGLIST=(compton lemonbar-xft-git tamzen-font-git siji-git ttf-meslo \
	flat-remix-gtk ttf-ms-fonts ttf-vista-fonts)
OYPKGLIST=(google-chrome-beta google-talkplugin sublime-text peaclock \
	virtualbox-ext-oracle)

ALL="f"

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

		# Check if yay (AUR helper of choice) is installed {{{
		if pacman -Qq yay; then
			echo "${green}Found yay...${end}"
		else
			echo -n "Missing ${red}yay${end}. Would you like to install it? [Y/n] (enter=Y) "
			read -a AURHELPER
			printf "\n"

			# If the user wants to install yay
			if [[ ${AURHELPER[*]} == "" || ${AURHELPER[*]} == "Y" ]]; then
				# Check if the necessary packages for yay are installed
				if pacman -Qq git && pacman -Qq base-devel; then
					echo "${green}Found necessary dependencies for yay...${end}"
				else
					echo -n "Missing ${red}yay${end} dependencies (some of: ${red}git${end}, ${red}base-devel${end}). Would you like to install them? [Y/n] (enter=Y) "
					read -a AURHELPER
					printf "\n"

					# If the user wants to install the dependencies
					if [[ ${AURHELPER[*]} == "" || ${AURHELPER[*]} == "Y" ]]; then
						# Install the 2 dependencies
						sudo pacman -S --needed --noconfirm git base-devel
						if git clone https://aur.archlinux.org/yay.git yay; then
							cd yay
							makepkg -si
							cd ..
						else
							echo "${red}Failed to download yay. Cannot continue...${end}"
							exit 1
						fi
					# If the user does not want to install the dependencies
					else
						echo "Missing some of: ${red}git${end}, ${red}base-devel${end}. Cannot continue..."
						exit 1
					fi
				fi
			# If the user does not want to install yay.
			else
				echo "Missing ${red}yay${end}. Cannot continue..."
				exit 1
			fi
		fi
		# }}}
	elif [[ $i == "OYPKGLIST" ]]; then
		CPKGL=("${OYPKGLIST[@]}")
	else
		CPKGL=("${PKGLIST[@]}")
	fi

	if [[ $ALL != "t" ]]; then
		echo
		printf "${blue}Packages: (${CPKGL[*]})\n${end}"
		echo "Type any non-number/whitespace character(s) (besides \"skip\" to continue)"
		echo -n "${cyan}==> Enter n° of packages to be installed (ex: 1 2 3) " \
			"(enter=all, !=all of every package list)${end} "
		read -a INPUT
		printf "\n"
		# If the user wants to install everything
		if [[ ${INPUT[*]} == "!" ]]; then
			ALL="t"
			INPUT=""
		fi
	fi

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
		continue
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

	# Go through the package list and install all the packages
	for j in $pkg; do
		if [[ $i == "YPKGLIST" ]] || [[ $i == "OYPKGLIST" ]]; then
			yay -S ${CPKGL[j-1]} --noconfirm
		else
			sudo pacman -S ${CPKGL[j-1]} --noconfirm --needed
		fi
	done
done

# Configure git stuff (tba)
