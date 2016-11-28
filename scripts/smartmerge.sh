# Reroute stderr to /dev/null/
# 2> /dev/null

red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

DiffAppend="DIFF"
ffdir="/home/me/Desktop"
fsdir="/home/me/Desktop"

IFS=$'\n'

if [[ -z $1 ]]; then
	echo "No parameters provided. Exiting..."
	exit 1;
else
	ffdir=$1
fi
if [[ -z $2 ]]; then
	echo "Missing second parameters. Exiting..."
	exit 1;
else
	fsdir=$2
fi
# if third parameter is not specified, make the tab = nothing/""
if [[ -z $3 ]]; then
	tab=""
else
	tab=$3
fi

Firstfl=$(ls -A1 "$ffdir")
Secondfl=$(ls -A1 "$fsdir")

nodiff=0
diff=0
noexist=0

for file in $Firstfl; do

	if [[ -d $ffdir$file ]]; then
		printf "\n$tab${magenta}specified file ($file) is a directory. Beginning recursion...\n$end"
		# Make folder(s) if they need to be made
		mkdir -p "$fsdir$file"
		sh $0 "$ffdir${file}/" "$fsdir${file}/" "$tab  "
	fi

	ffile="$ffdir$file"
	sfile="$fsdir$file"

	diff=$(cmp -s "$ffile" "$sfile" 2> /dev/null; echo $?)
	# There was no difference between the two files
	if [[ $diff == "0" ]]; then
		let nodiff+=1
	# The files are different. Copy and rename
	elif [[ $diff == "1" ]]; then
		let diff+=1
		cp "$ffile" "$sfile$DiffAppend" 2> /dev/null
	# The file does not exist in one of the directories, but we know that means
	# the second directory
	elif [[ $diff == "2" ]]; then
		let noexist+=1
		cp "$ffile" "$sfile" 2> /dev/null
	fi

	echo -en "\r$tab${green}[$nodiff] files are the same ${red}[$diff] \
					files are different ${cyan}[$noexist] files do not exist \
					in the second dir$end"
done
echo

unset IFS
