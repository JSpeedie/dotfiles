# Installing the packages for the system
# {{{
echo -n "Would you like to install all the packages from my package lists? [Y/n] (enter=Y) "
read -a ANSWER
printf "\n\n"

# If the user wants to install the packages
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	echo -n "Are you restoring your setup on an Arch-based distro or a Debian-based distro? [arch/debian] (enter=arch) "
	read -a ANSWER
	printf "\n"

	if [[ ${ANSWER[*]} == "arch" || ${ANSWER[*]} == "" ]]; then
		bash scripts/packages-arch.sh
		printf "\n"
	elif [[ ${ANSWER[*]} == "debian" ]]; then
		bash scripts/packages-debian.sh
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


# "Installing" the dotfiles in the home directory
# {{{
echo -n "Would you like to copy your dotfiles to your home directory? [Y/n] (enter=Y) "
read -a ANSWER
printf "\n"

# If the user wants to copy over the dotfiles from the dotfiles git repo to their home folder
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	bash scripts/copy-dotfiles.sh
	printf "\n"
else
	printf "\n"
	printf "Skipping over copying the dotfiles into the home directory.\n\n"
fi
# }}}


# Configuring the restored setup
# {{{
echo -n "Would you like to configure your setup? [Y/n] (enter=Y) "
read -a ANSWER
printf "\n"

# If the user wants configure their setup
if [[ ${ANSWER[*]} == "Y" || ${ANSWER[*]} == "" ]]; then
	bash scripts/configure.sh
	printf "\n"
else
	printf "\n"
	printf "Skipping over configuring the setup.\n\n"
fi
# }}}
