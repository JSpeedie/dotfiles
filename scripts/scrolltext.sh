# Prints scrolled version of given text starting from a given index to a given
# length to stdout

# Takes 3 arguments.
# 1. String to scroll
# 2. Starting index to grab from
# 3. Length of output

input_string=$1
start_index=$2
full_len=$3
let len_output=$3-1

while [[ ${#input_string} -lt $full_len ]]; do
	input_string=$(printf "$input_string ")
done

ret=""

for i in $(seq 0 $len_output); do
	pos=$(echo "$start_index $i ${#input_string}" | awk '{print ($1 + $2) % $3}')
	# Get 1 char from (start_index + i)th position in 'input_string'
	ret+=${input_string:$pos:1}
done
echo "$ret"
let start_index=$start_index+1
