# A script for printing the terminal colours from 0-7 on row 1, then 8-15 on
# row 2. Can take 0 to 2 arguments. If given 1 argument, the height of the
# blocks of colour that make up the output is set to that number. If 2
# arguments are given, the first will refer to the width of the blocks, the
# second to the height. If given no arguments, the scripts defaults to a width
# of 4 and a height of 1.
#
# $ sh colortest.sh 1 2
# █ █ █ █ █ █ █ █
# █ █ █ █ █ █ █ █
# █ █ █ █ █ █ █ █
# █ █ █ █ █ █ █ █
# $ sh colortest.sh 4 1
# ████ ████ ████ ████ ████ ████ ████ ████
# ████ ████ ████ ████ ████ ████ ████ ████

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

# Default width and height
bwidth=4
bheight=1

# If a second argument was NOT given, but the first argument was
if [[ -z $2 && ! -z $1 ]]; then
	bheight=$1
# If two arguments were given
elif [[ ! -z $2 && ! -z $1 ]]; then
	bheight=$2
	bwidth=$1
fi

# Create a row of blocks based on the specified (or default) width
block_row=""
for i in $(seq $bwidth); do
	block_row=$(echo "${block_row}█")
done

# Print the specified (or default) number of rows.
for i in $(seq $bheight); do
	printf "$color0${block_row} "
	printf "$color1${block_row} "
	printf "$color2${block_row} "
	printf "$color3${block_row} "
	printf "$color4${block_row} "
	printf "$color5${block_row} "
	printf "$color6${block_row} "
	printf "$color7${block_row}"
	printf "$end\n"
done
for i in $(seq $bheight); do
	printf "$color08${block_row} "
	printf "$color09${block_row} "
	printf "$color10${block_row} "
	printf "$color11${block_row} "
	printf "$color12${block_row} "
	printf "$color13${block_row} "
	printf "$color14${block_row} "
	printf "$color15${block_row}"
	printf "$end\n"
done

