# Improvements: {{{
# 1. Have a separate list of windows that you want to first
# check if theres an instance of them (steam) before creating them
# If there is an instance remove them from their lists??? idk
# 2. Switch to use bspwm rules instead of moving each window manually
# Same effect? First window of that type gets moved, but it's instant.
# Two arrays? one sets the rules before the
# script really starts and the other removes the rules
# when the window was created. Problems, one more array i think. }}}

# Variables {{{
# List of windows managed by bspwm
currentWin=$(bspc query --windows)
# A string list of window ids that will excluded from sorting.
# At this point it consists of windows that exist before
# we created any.
sortedIds=$(echo $currentWin)
# Windows to make upon start up
Win=(firefox google-chrome-beta urxvt urxvt) 
# The WM_CLASS name of the windows you want to sort/move
WinNames=(Firefox google-chrome-beta URxvt URxvt)
# The desktops you want each window to be sorted/moved to
WinDesktop=(6 2 8 8)
# }}}

# Create a new instance of all the programs you want to start
for window in ${Win[@]}; do
	nohup $window &>/dev/null &
done

# Explanation of code below {{{
# The idea of the following code is that every x seconds (set in the while loop)
# it grabs the list of all bspwm windows and loops through their ids grabbing their
# class name (using xprop). If the WM_CLASS name of the window is that
# of a window we want to move (any entry in $WinNames) and it hasn't been sorted
# already (not in $sortedIds), move it to its specified desktop.
# The desktop it is sent to is specified in $WinDesktop where if a window
# of name ${WinNames[$i]} is found and it has not been sorted, will be moved
# to desktop ${WinDesktop[$i]} }}}

numSort=0
# While we have not created all windows and moved them to their desktop
while [[ $numSort -lt ${#WinNames[@]} ]]; do
	# goes through the list of window ids
	for win in $(bspc query --windows); do 
		# if the window has not already been moved/sorted
		if [[ $sortedIds != *"$win"* ]]; then
			# WM_CLASS name of the window (ex. Firefox, URxvt)
			name=$(xprop -id $win | grep "WM_CLASS" | tr ' ' '\n' | grep -o "\".*\"$" | sed "s/\"//g")

			num=0
			# for all the windows we are sorting/moving in this script
			for i in ${WinNames[@]}; do 
				# if $win is a window we need to move
				if [[ "$name" == "$i" ]]; then
					# bspc bash command to move a window of id $win
					# to desktop of ${WinDesktop[$num]}
					bspc window $win -d ^${WinDesktop[$num]}
					# add 1 to the number of sorted windows
					let numSort+=1
					# Add to the list of windows that must be ignored
					sortedIds+=" $win"
					break
				fi
				let num+=1
			done
		fi
	done 
	sleep 1
done 

# Greet the user ;)
notify-send "Welcome back, fuckface"
# Focus on the right desktop
bspc desktop -f ^1
bspc desktop -f ^6
echo "Successfully ran start up script"
