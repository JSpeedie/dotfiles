
# Return all versions of scrolled text to stdout
# Responsibility of program using this script to account for the size of the
# array
# Number length indicating the given length of the string the user wants.
# Grab start to (start + length) % length chars.


# Takes 3 arguments.
# 1. 'Number of chars to grab'
# 2. 'String to scroll'
# 3. 'Starting index to grab from'

current=$3
let chars=$1-1

print_out=""
# Loop length_of_the_string times
for i in $(seq 0 $chars); do
	let current_plus_i=$current+$i
	pos=$(echo "$current_plus_i ${#2}" | awk '{print $1 % $2}')
	# Get 1 char from ith position in string $2
	print_out+=${2:$pos:1}
done
echo "$print_out"
let current=$current+1
