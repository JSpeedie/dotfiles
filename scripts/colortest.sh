end=$'\e[0m'
color0=$'\e[0;30m'
color1=$'\e[0;31m'
color2=$'\e[0;32m'
color3=$'\e[0;33m'
color4=$'\e[0;34m'
color5=$'\e[0;35m'
color6=$'\e[0;36m'
color7=$'\e[0;37m'

color08=$'\e[1;30m'
color09=$'\e[1;31m'
color10=$'\e[1;32m'
color11=$'\e[1;33m'
color12=$'\e[1;34m'
color13=$'\e[1;35m'
color14=$'\e[1;36m'
color15=$'\e[1;37m'
block='█'
# If there is no first argument
if [[ -z $1 ]]; then
	printf "$color0████ "
	printf "$color1████ "
	printf "$color2████ "
	printf "$color3████ "
	printf "$color4████ "
	printf "$color5████ "
	printf "$color6████ "
	printf "$color7████ "
	printf "$end\n"
	printf "$color08████ "
	printf "$color09████ "
	printf "$color10████ "
	printf "$color11████ "
	printf "$color12████ "
	printf "$color13████ "
	printf "$color14████ "
	printf "$color15████ "
	printf "$end\n"
# If a command line argument is given, print that many rows for each colour
else
	# If there is a first argument but no second argument
	if [[ -z $2 ]]; then
		for i in $(seq $1); do
			printf "$color0████ "
			printf "$color1████ "
			printf "$color2████ "
			printf "$color3████ "
			printf "$color4████ "
			printf "$color5████ "
			printf "$color6████ "
			printf "$color7████ "
			printf "$end\n"
		done
		for i in $(seq $1); do
			printf "$color08████ "
			printf "$color09████ "
			printf "$color10████ "
			printf "$color11████ "
			printf "$color12████ "
			printf "$color13████ "
			printf "$color14████ "
			printf "$color15████ "
			printf "$end\n"
		done
	# If there is a first and second argument
	else
		block_out=""
		for i in $(seq $1); do
			block_out=$(echo "${block_out}${block}")
		done
		for i in $(seq $2); do
			printf "$color0${block_out} "
			printf "$color1${block_out} "
			printf "$color2${block_out} "
			printf "$color3${block_out} "
			printf "$color4${block_out} "
			printf "$color5${block_out} "
			printf "$color6${block_out} "
			printf "$color7${block_out} "
			printf "$end\n"
		done
		for i in $(seq $2); do
			printf "$color08${block_out} "
			printf "$color09${block_out} "
			printf "$color10${block_out} "
			printf "$color11${block_out} "
			printf "$color12${block_out} "
			printf "$color13${block_out} "
			printf "$color14${block_out} "
			printf "$color15${block_out} "
			printf "$end\n"
		done
	fi
fi

