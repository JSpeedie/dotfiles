#!/usr/bin/env bash
#
# Takes 3 arguments:
#
# $1 = The directory that roots the first directory tree
# $2 = The directory that roots the second directory tree
# $3 = A path to a program that when run in the second root directory will
#      return a list of files contained somewhere within the directory,
#      filtered by the program.
# 
# To be clear, by "root directory" here, I do not mean /the/ root directory "/"
# but rather a directory that roots a given directory tree that we are
# interested in.
#
# Example:
#
# ./updatedir ~/ ~/dotfiles/ ~/scripts/updatedir-dotfiles-filelist
#
# This is the use case I designed this script for. It takes the current user's
# home directory (~/) and their dotfiles directory (~/dotfiles/) and then uses
# a script (~/scripts/updatedir-dotfiles-filelist) to produce a list of
# relative filepaths which will be appended, one by one, to both the first root
# directory and the second root directory, comparing the two resulting files.
# If the files differ, this script will prompt the user to replace the file in
# the first directory tree with the one found in the second directory tree.
# The user can say "Y" to follow through, "n" to take no action, "c" to compare
# the two files in a diff editor, or "r" to revert the file, replacing the file
# in the second directory tree with its counterpart in the first directory tree.

# Used to colour the ouput
red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

# Default values
FIRST_DIR=(~)
SECOND_DIR=(~)

# Check the arguments given to the script
if [[ -n "$1" ]]; then
	# Strip possible trailing "/"
	FIRST_DIR=$(echo "$1" | sed "s/\/$//")

	if [[ -n "$2" ]]; then
		# Strip possible trailing "/"
		SECOND_DIR=$(echo "$2" | sed "s/\/$//")
	else
		echo "No second directory provided. Exiting..."
		exit 1
	fi

	if [[ -n "$3" ]]; then
		# If the filter script file is a file that exists and is executable
		if [[ -x "$3" ]]; then
			# If the file path given was absolute (full)
			# TODO: does this work with paths that were specified beginning
			# with a "~"? I think so, but I'm not certain
			if [[ ${3:0:1} == "/" ]]; then
				# Generate the relative file-path list
				REL_FILE_LIST=($(cd $SECOND_DIR; $3))
			# If the file path given was relative
			else
				# Generate the relative file-path list
				REL_FILE_LIST=($(cd $SECOND_DIR; $(pwd)/${3}))
			fi
		else
			echo "Filter script file provided either does not exist or is" \
				"not readable. Exiting..."
			exit 1
		fi
	fi
else
	echo "No first directory provided. Exiting..."
	exit 1
fi


# Used for when a user inputs "c" to compare two files. This would usually
# Output the usual file comparison output (files differ, [Y/n/c/r], etc)
# the purpose of this function is to remove the first comparison output.
#
# Takes 1 argument, an integer representing how many lines in the terminal are
# to be erased, starting at the line the cursor is currently on and moving
# upward.
function removeLinesAbove {
	lines_to_erase=$1
	# Set cursor position to the beginning of the line
	tput hpa 0
	for i in $(seq $lines_to_erase); do
		# Clear to end of line
		tput el
		# Go up a line
		if [[ $i -lt $lines_to_erase ]]; then
			tput cuu1
		fi
	done
}


# Checks files to see if it's different, asks user if they want to replace the
# first file, not replace the first file, compare the two files, or replace the
# second file.
function compareFileInTwoDirectories {
	if [[ -d ${FIRST_DIR}/${file} ]]; then
		return
	fi

	difftest=$(cmp -s ${FIRST_DIR}/${file} ${SECOND_DIR}/${file}; echo $?)

	# If the files are different
	if [[ "$difftest" != "0" ]]; then
		echo "$red==> The files differ$end"
		echo "Y=Yes, n=no, c=compare r=revert"
		printf "Update $file? [Y/n/c/r] "
		read ANS
		# Default to "Y" (hitting enter is equivalent to entering "Y")
		if [[ $ANS == "Y" ]] || [[ $ANS == "" ]]; then
			cp -iv ${FIRST_DIR}/${file} -T ${SECOND_DIR}/${file}
		elif [[ $ANS == "n" ]]; then
			echo "Continuing to next file..."
		elif [[ $ANS == "c" ]]; then
			vimdiff ${FIRST_DIR}/${file} ${SECOND_DIR}/${file}
			# Remove previous output to avoid confusion upon re-reading it
			# 1 for "==>" files do/don't differ line
			# 1 for Y=Yes line
			# 1 for Update file [Y/n/c/r] line
			# 1 for output of vimdiff ("2 files to edit")
			# 1 for echo "" for space for compareFileInTwoDirectories
			removeLinesAbove 5
			compareFileInTwoDirectories
		elif [[ $ANS == "r" ]]; then
			cp -iv ${SECOND_DIR}/${file} -T ${FIRST_DIR}/${file}
		else
			echo "Invalid input. Exiting..."
			exit 1
		fi

		echo ""
	fi
}


# Go through all the files in the second directory and compare to first
# directory equivalent of the file.
for file in ${REL_FILE_LIST[@]}; do
	compareFileInTwoDirectories;
done
echo "Done!"
