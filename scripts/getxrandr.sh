# Notes:
#
# sort -rn
# Sort as numbers (as opposed to as strings), and reverse the order so the
# number appears first
#
# sed "1p;d"
# go to line 1, print; quit/exit. Fast version of head -n 1??
#
# grep " connected" -A 1
# Print 1 line after the line that matches " connected"
#
# sed -n "/$outputs/,/^\S/{//!p}"
# Get all the lines exclusively between the first pattern ($outputs) and
# the second (^\S). \S is any NON-whitespace.
#
# grep -o "^DP.\?[0-9]"
# \? means [0-9] is optional

# TODO: select primary monitor based on resolution, not "highest number DP"

outputs=$(xrandr | grep -o "^.* connected" | sed "s/ connected//g")
# For the foreseeable future I will want the monitor that is hooked up through
# the highest number DiplayPort to be my primary monitor
displayportconns=$(echo "$outputs" | grep -o "^DP.\?[0-9]" | awk '{print $1}')
primary_outp=$(echo "$displayportconns" | sort | tail -n 1)

final_out="xrandr "

# For each monitor:
for outp in $(echo "$outputs"); do
	# 0. Get a string of all its options that we will reuse
	monitoroptions=$(xrandr | sed -n "/$outp/,/^\S/{//!p}")
	# 1. Find its highest resolution (assumption: it's the
	# first one (top most) in the list produced by the xrandr command)
	resolution=$(printf "$monitoroptions\n" | sed "1p;d" \
		| grep -o "[0-9]\+x[0-9]\+")
	# 2. Find the refresh rates available for that resolution and select the
	# fastest refresh rate.
	refreshrate=$(printf "$monitoroptions\n" | grep "$resolution" \
		| grep -o "[0-9]\{1,3\}\.[0-9]\{1,2\}" | sort -rn | sed "1p;d")

	final_out+="--output $outp --mode $resolution --rate $refreshrate "
	if temp=$(echo "$outp" | grep "^$primary_outp"); then
		final_out+="--primary "
	else
		final_out+="--left-of $primary_outp "
	fi
done

# For debugging
# echo "$final_out" >> ~/getxrandr.sh.out
echo "$final_out"
