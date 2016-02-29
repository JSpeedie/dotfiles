red=$'\e[1;31m'
green=$'\e[1;32m'
yellow=$'\e[1;33m'
blue=$'\e[1;34m'
magenta=$'\e[1;35m'
cyan=$'\e[1;36m'
end=$'\e[0m'

DiffAppend="DIFF"
First="/run/media/me/P1/Backups/Pictures/"
Second="/run/media/me/P1/Backups/Pictures/"
first=""
second="" 

echo "Copies files from First and smart merges them into Second"
echo "Be sure to add an \"/\" to the end of any path you add"
echo

printf "Use/add to default locations? [Y/n] "
read ANS

if [[ $ANS == "Y" ]]; then 
	printf "First location \"$First\" : "
	read -e first

	printf "Second location \"$Second\" : "
	read -e second 
elif [[ $ANS == "n" ]]; then
	printf "First location : "
	read -e First

	printf "Second location : "
	read -e Second 
fi

echo
echo "Beginning!"
echo

ffdir=$First$first
fsdir=$Second$second

Firstfl=$(ls -A1 "$ffdir")
Secondfl=$(ls -A1 "$fsdir")
ffl=()

for file in $Firstfl; do
	# Second folder has the file too
	if [[ $Secondfl == *$file* ]]; then
		echo "${green}Second folder also has file$end"
	else
		echo "${red}Second folder does NOT have file$end"
		ffl+=($file)
	fi
done
for file in $Secondfl; do
	# First folder has the file too
	if [[ $Firstfl == *$file* ]]; then
		echo "${green}First folder also has file$end"
	else
		echo "${red}First folder does NOT have file$end"
		ffl+=($file)
	fi
done

