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

		# Check if yaourt is installed {{{
		if pacman -Q | grep "^yaourt"; then
			echo "${green}Found yaourt...${end}"
		else
			echo -n "Missing ${red}yaourt${end}. Would you like to install it? [Y/n] (enter=Y) "
			read -a YAOURT
			printf "\n"

			# If the user wants to install yaourt
			if [[ ${YAOURT[*]} == "" || ${YAOURT[*]} == "Y" ]]; then
				# Check if the necessary AUR package (package-query) for yaourt is installed
				if pacman -Q | grep "^package-query"; then
					echo "${green}Found package-query...${end}"
				else
					echo -n "Missing ${red}yaourt${end} dependency ${red}package-query${end}. Would you like to install it? [Y/n] (enter=Y) "
					read -a YAOURT
					printf "\n"

					# If the user wants to install package-query
					if [[ ${YAOURT[*]} == "" || ${YAOURT[*]} == "Y" ]]; then
						# Install 3 dependencies necessary for
						# building package-query
						if ! pacman -Qq pkgconfig; then
							echo "Missing ${red}pkgconfig${end}, installing..."
							sudo pacman -S pkgconfig --noconfirm --needed
						fi
						if ! pacman -Qq make; then
							echo "Missing ${red}make${end}, installing..."
							sudo pacman -S make --noconfirm --needed
						fi
						if ! pacman -Qq fakeroot; then
							echo "Missing ${red}fakeroot${end}, installing..."
							sudo pacman -S fakeroot --noconfirm --needed
						fi
						if git clone https://aur.archlinux.org/package-query.git package-query; then
							cd package-query
							makepkg -sri
							cd ..
						else
							echo "${red}Failed to download package-query. Cannot continue...${end}"
							exit 1
						fi
					# If the user does not want to install package-query.
					else
						echo "Missing ${red}package-query${end}. Cannot continue..."
						exit 1
					fi
				fi
				if git clone https://aur.archlinux.org/yaourt.git yaourt; then
					cd yaourt
					makepkg -sri
					cd ..
				else
					echo "${red}Failed to download yaourt. Cannot continue...${end}"
					exit 1
				fi
			# If the user does not want to install yaourt.
			else
				echo "Missing ${red}yaourt${end}. Cannot continue..."
				exit 1
			fi
			# }}}
		fi
	elif [[ $i == "OYPKGLIST" ]]; then
		CPKGL=("${OYPKGLIST[@]}")
	else
		CPKGL=("${PKGLIST[@]}")
	fi

	if [[ $ALL != "t" ]]; then
		echo
		printf "${blue}Packages: (${CPKGL[*]})\n${end}"
		echo "Type any non-number/whitespace character(s) (besides \"skip\" to continue"
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


	for j in $pkg; do

		if [[ $i == "YPKGLIST" ]] || [[ $i == "OYPKGLIST" ]]; then
			yaourt ${CPKGL[j-1]} --noconfirm
		else
			sudo pacman -S ${CPKGL[j-1]} --noconfirm --needed
		fi
	done
done

# Configure git stuff (tba)
