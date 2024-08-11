# Installs everything needed for my setup including packages for base
# functionality, my most commonly used apps, programs I use to build my setup,
# programs I use for development, and so on.

red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

BASEPKGLIST=(rxvt-unicode xorg libnotify4 pulseaudio pamixer sxhkd rsync \
	cronie dialog pavucontrol)
APPPKGLIST=(firefox nautilus evince gimp libreoffice obs-studio eog vlc \
	mpv audacity ranger pitivi)
# I think I'm done with lemonbar. Time to investigate maybe polybar or waybar
EXTRAPKGLIST=(rofi feh dunst compton scrot screenfetch numlockx \
	network-manager stalonetray gnome-control-center lxappearance \
	cmatrix figlet lolcat sl)
# 'linux-tools-common' for 'perf'
DEVPKGLIST=(tree jq \
	vim neovim universal-ctags \
	make cmake fakeroot \
	git subversion \
	valgrind gdb linux-tools-common \
	pandoc texlive-full \
	openssh-client openssh-server \
	xterm \
	clang \
	virtualbox virtualbox-guest-utils \
	autoconf automake \
	python3 python3-pip \
	nodejs npm \
	ghex)
# racket ghc ghc-static \
#jre8-openjdk java-runtime-common java-environment-common \
FONTPKGLIST=(fonts-roboto fonts-noto)
FSPKGLIST=(dosfstools mtools ntfs-3g \
	unzip zip unrar)
ALL="f"


cd ~
clear
printf "$blue"
printf " ╔════════════════════════════════════════════════╗ \n"
printf " ║                  SETUP SCRIPT                  ║ \n"
printf " ╚════════════════════════════════════════════════╝ \n"
printf "          Script for: Debian-based Distros          \n"
printf "$end\n"

for i in $(printf "BASEPKGLIST\nAPPPKGLIST\nEXTRAPKGLIST\nDEVPKGLIST\nFONTPKGLIST\nFSPKGLIST"); do
	if [[ $i == "BASEPKGLIST" ]]; then
		CPKGL=("${BASEPKGLIST[@]}")
	elif [[ $i == "APPPKGLIST" ]]; then
		CPKGL=("${APPPKGLIST[@]}")
	elif [[ $i == "EXTRAPKGLIST" ]]; then
		CPKGL=("${EXTRAPKGLIST[@]}")
	elif [[ $i == "DEVPKGLIST" ]]; then
		CPKGL=("${DEVPKGLIST[@]}")
	elif [[ $i == "FONTPKGLIST" ]]; then
		CPKGL=("${FONTPKGLIST[@]}")
	elif [[ $i == "FSPKGLIST" ]]; then
		CPKGL=("${FSPKGLIST[@]}")
	else
		continue
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

	PKGS=""

	# Go through the specified packages and create a list we can pass to
	# our package manager
	for j in $pkg; do
		PKGS+="${CPKGL[j-1]} "
	done

	echo "Packages to be installed: ${PKGS[*]}"

	sudo apt install --assume-yes ${PKGS[*]}
done
