#!/bin/bash

First=(~/)
Second=(~/)

if [[ -n "$1" ]]; then
	First=$1

	if [[ -n "$2" ]]; then
		Second=$2
	else
		echo "No second directory provided. Exiting..."
		exit 1
	fi

	if [[ -n "$3" ]]; then
		# If the filter script file is a file that exists and is readable
		if [[ -r "$3" ]]; then
			# If the file path given was absolute (full)
			if [[ ${3:0:1} == "/" ]]; then
				FLIST=($(cd $Second; sh $3))
			# If the file path given was relative
			else
				dir_called_from=$(pwd)
				FLIST=($(cd $Second; sh ${dir_called_from}/${3}))
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

# Used to colour the ouput
red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'


# Used for when a user inputs "c" to compare two files. This would usually
# Output the usual file comparison output (files differ, [Y/n/c/r], etc)
# the purpose of this function is to remove the first comparison output.
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

# Checks files to see if it's different, asks user if they want to replace,
# not replace, or compare the two files.
function nextFile {
	if [[ -d $First$file ]]; then
		return
	fi

	difftest=$(cmp -s $First$file $Second$file; echo $?)

	# If the files are different
	if [[ $difftest != "0" ]]; then
		echo "$red==> The files differ$end"
		echo "Y=Yes, n=no, c=compare r=revert"
		printf "Update $file? [Y/n/c/r] "
		read ANS
		# Default to "Y" (hitting enter is equivalent to entering "Y")
		if [[ $ANS == "Y" ]] || [[ $ANS == "" ]]; then
			cp -v $First$file -T $Second$file;
		elif [[ $ANS == "n" ]]; then
			echo "Continuing to next file..."
		elif [[ $ANS == "c" ]]; then
			vimdiff $First$file $Second$file
			# Remove previous output to avoid confusion upon re-reading it
			# 1 for "==>" files do/don't differ line
			# 1 for Y=Yes line
			# 1 for Update file [Y/n/c/r] line
			# 1 for output of vimdiff ("2 files to edit")
			# 1 for echo "" for space for nextFile
			removeLinesAbove 5
			nextFile
		elif [[ $ANS == "r" ]]; then
			cp -iv $Second$file -T $First$file ;
		else
			echo "Invalid input. Exiting..."
			exit 1
		fi

		echo ""
	fi
}


# Go through all the files in the second directory and compare to first
# directory equivalent of the file.
for file in ${FLIST[@]}; do
	nextFile;
done
echo "Done!"
