# Installing the packages for the system

red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'
bold=$(tput bold)
normal=$(tput sgr0) 

# Stores the full, absolute path to the directory this script is in. This is
# used to call "sibling" scripts this script expects to be in the same
# directory.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Functional alternative, but realpath may(???) not be installed on all systems
# SCRIPT_DIR="$(dirname "$(realpath "$0")")"

clear
printf "$bold"
printf " ╔══════════════════════════════════════════════════════╗\n"
printf " ║               SETUP RESTORATION SCRIPT               ║\n"
printf " ╚══════════════════════════════════════════════════════╝\n"
printf "$normal"
printf " ┏━━━━━━━━━━━━━┓   ┌──────────────┐   ┌─────────────────┐\n"
printf " ┃ 1. Install  ┃ ╲ │ 2. Copy Over │ ╲ │ 3. Configure    │\n"
printf " ┃    Packages ┃ ╱ │    Dotfiles  │ ╱ │    Installation │\n"
printf " ┗━━━━━━━━━━━━━┛   └──────────────┘   └─────────────────┘\n"
printf "$end\n"
echo


# {{{
echo -n "Would you like to install the packages from my package lists? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n\n"

# If the user wants to install the packages
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	echo -n "Are you restoring your setup on an Arch-based distro or a Debian-based distro? [arch/debian] (enter=arch): "
	read -a ANSWER
	printf "\n"

	if [[ ${ANSWER[*]} == "arch" || ${ANSWER[*]} == "" ]]; then
		bash ${SCRIPT_DIR}/packages-arch.sh
		printf "\n"
	elif [[ ${ANSWER[*]} == "debian" ]]; then
		bash ${SCRIPT_DIR}/packages-debian.sh
		printf "\n"
	else
		printf "\n"
		printf "No valid distro chosen - restore.sh cannot choose which package script to call.\n\n"
	fi
else
	printf "\n"
	printf "Skipping over installing packages.\n\n"
fi
# }}}


printf "$bold"
printf " ╔══════════════════════════════════════════════════════╗\n"
printf " ║               SETUP RESTORATION SCRIPT               ║\n"
printf " ╚══════════════════════════════════════════════════════╝\n"
printf "$normal"
printf " ┌─────────────┐   ┏━━━━━━━━━━━━━━┓   ┌─────────────────┐\n"
printf " │ 1. Install  │ ╲ ┃ 2. Copy over ┃ ╲ │ 3. Configure    │\n"
printf " │    Packages │ ╱ ┃    dotfiles  ┃ ╱ │    installation │\n"
printf " └─────────────┘   ┗━━━━━━━━━━━━━━┛   └─────────────────┘\n"
printf "$end\n"
echo


# "Installing" the dotfiles in the home directory
# {{{
echo -n "Would you like to copy your dotfiles to your home directory? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

# If the user wants to copy over the dotfiles from the dotfiles git repo to their home folder
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	bash ${SCRIPT_DIR}/copy-dotfiles.sh
	printf "\n"
else
	printf "\n"
	printf "Skipping over copying the dotfiles into the home directory.\n\n"
fi
# }}}


printf "$bold"
printf " ╔══════════════════════════════════════════════════════╗\n"
printf " ║               SETUP RESTORATION SCRIPT               ║\n"
printf " ╚══════════════════════════════════════════════════════╝\n"
printf "$normal"
printf " ┌─────────────┐   ┌──────────────┐   ┏━━━━━━━━━━━━━━━━━┓\n"
printf " │ 1. Install  │ ╲ │ 2. Copy over │ ╲ ┃ 3. Configure    ┃\n"
printf " │    Packages │ ╱ │    dotfiles  │ ╱ ┃    installation ┃\n"
printf " └─────────────┘   └──────────────┘   ┗━━━━━━━━━━━━━━━━━┛\n"
printf "$end\n"
echo


# Configuring the restored setup
# {{{
echo -n "Would you like to configure your setup? [Y/n] (enter=Y): "
read -a ANSWER
printf "\n"

# If the user wants configure their setup
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	bash ${SCRIPT_DIR}/configure.sh
	printf "\n"
else
	printf "\n"
	printf "Skipping over configuring the setup.\n\n"
fi
# }}}
