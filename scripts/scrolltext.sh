#!/usr/bin/env bash
#
# Prints a given number of characters of a given string, starting at a
# specified index in the string. This is a helper script and its primary
# purpose is to scroll a given string within a confined space by repeatedly
# calling this script with the same first argument, and the same third
# argument, but incrementing the second argument, wrapping it to 0 once it
# reaches the length of the string. The example usage given below uses this
# script in this way.
#
# Takes 3 arguments.
# 1. A string to scroll
# 2. An integer representing the index of the string to print as the first
#    character. A safe default is 0.
# 3. An integer representing the number of characters the output field has room
#    to display.
#
# Example usage:
# for i in $(seq 0 50); do ./scripts/scrolltext.sh "test - command" $i 24; done

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
