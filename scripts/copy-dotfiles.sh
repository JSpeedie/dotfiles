######################################################################
#                              WARNING!                              #
######################################################################
#                                                                    #
#           Replaces all existing files of the same names.           #
#   This includes things like .bashrc and .Xresources. BE PREPARED!  #
#        Make sure this script is run from the same directory        #
#          You cloned the git repo into or it will not work.         #
#                                                                    #
######################################################################

red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

printf " ╔══════════════════════════════════════════════════════╗\n"
printf " ║                 2. Copy Over Dotfiles                ║\n"
printf " ╚══════════════════════════════════════════════════════╝\n"

# This script is used to "install" all the parts of the setup.

fontdir=/usr/share/fonts
MANUALINS=(font-awesome* otf-hermit*)
IGNORELIST=(\\.git README.md LICENSE)
parent_folder=$(git rev-parse --show-toplevel)

get_ignore_list () {
	ignoregrep=""
	# Creates a string used in a grep statement to retrieve only
	# the files NOT in MANUALINS and IGNORELIST
	for ignore in ${IGNORELIST[*]}; do
		ignoregrep=${ignoregrep}"\($ignore\)\|"
	done
	for ignore in ${MANUALINS[*]}; do
		ignoregrep=${ignoregrep}"\($ignore\)\|"
	done
	# Remove trailing "\|"
	ignoregrep=$(echo $ignoregrep | sed "s/.\{2\}$//")
}


copy_files () {
	# All the files and folders we want to copy in a newline delimited list
	files=$(cd $parent_folder; git ls-files | grep -v "$ignoregrep")

	# Print out all the files that will be copied
	# echo "${files[@]}"
	# printf "\n------------------------------------------------------------\n\n"

	for file in $files; do
		# If the given file has directories
		if [[ $(echo "$file" | grep "\/") ]]; then
			# File path removing everything after the last "/"
			# [^\/] matches any char that is NOT "/"
			necessary_folders=$(echo "$file" | sed "s/\/[^\/]*$//")
			# Create path for copying
			mkdir -p ~/$necessary_folders;
		fi
		sudo cp -Rv $file ~/$file
		# Change ownership to current user
		sudo chown $USER ~/$file
	done
}


get_ignore_list
copy_files
