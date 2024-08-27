#!/usr/bin/env bash
#
# Prints scrolled version of given text starting from a given index to a given
# length to stdout
#
# Prints a given number of characters of a given string, starting at a
# specified index in the string. This is a helper script and its primary
# purpose is to scroll a given string within a confined space by repeatedly
# calling this script with the same first argument, and the same second
# argument, but incrementing the third argument, wrapping it to 0 once it
# reaches the length of the string. The example usage given below uses this
# script in this way.
#
# Takes 3 arguments.
# 1. An integer representing the number of characters that can be displayed in
#    the output field.
# 2. A string representing the text to be scrolled.
# 3. An integer representing the index of the string to print as the first
#    character. A safe default is 0.
#
# Example usage:
# for i in $(seq 0 50); do ./scripts/scrolltext2.sh 24 "test - command" $i; done

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
