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
currentWin=$(bspc query --nodes)
# A string list of window ids that will excluded from sorting.
# At this point it consists of windows that exist before
# we created any.
sortedIds=$(echo $currentWin)
# Windows to make upon start up
Win=(firefox google-chrome-beta\ --app=http://netflix.com/browse urxvt urxvt)
# The WM_CLASS name of the windows you want to sort/move
WinNames=(Firefox google-chrome-beta URxvt URxvt)
# The desktops you want each window to be sorted/moved to
WinDesktop=(6 2 8 8)
# }}}

# Add a delay so .Xresources can be read
sleep 2
Processes=()
# Create a new instance of all the programs you want to start
for ((i = 0; i < ${#Win[@]}; i++)) do
	nohup ${Win[$i]} &>/dev/null &
	Processes+=("$!")
done

echo "begin" > ~/startOut
echo "Processes \"${Processes[@]}\"" >> ~/startOut

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
let startTime=$(date +%s)
if [[ -z $1 ]]; then
	let timeOut=40
elif [[ -n $1 ]]; then
	let timeOut=$1
else
	let timeOut=40
fi
# While we have not created all windows and moved them to their desktop
# The script will exit if it does not finish after a user set number of  seconds
while [[ $numSort -lt ${#WinNames[@]} ]] && [[ $timeSpent -le $timeOut ]]; do
	# goes through the list of window ids in X session
	for win in $(bspc query --nodes); do
		# if the window $win has not already been moved/sorted
		if [[ $sortedIds != *"$win"* ]]; then
			# WM_CLASS name of the window (ex. Firefox, URxvt)
			name=$(xprop -id $win | grep "WM_CLASS" | tr ' ' '\n' | grep -o "\".*\"$" | sed "s/\"//g")
			pid=$(xprop -id $win | grep "PID" | grep -o "[0-9]\+")
			echo "sortedIds \"$sortedIds\" unsorted_win_name=\"$name\" unsorted_win_pid=\"$pid\"" >> ~/startOut

			num=0
			# for all the windows we are sorting/moving in this script
			for i in ${WinNames[@]}; do 
				printf "\tunsorted_win_pid: \"$pid\" unsorted_win_name: \"$name\" comparing: \"$i\" processes_from_script: \"${Processes[*]}\"\n" >> ~/startOut
				# Check to see if the window is one we've created
				if [[ "${Processes[@]}" == *"$pid"* ]]; then
					echo "checking window of pid \"$pid\"" >> ~/startOut
					# if $win is a window we need to move
					if [[ "$name" == "$i" ]]; then
						# bspc bash command to move a window of id $win
						# to desktop of ${WinDesktop[$num]}
						bspc node $win -d ^${WinDesktop[$num]}
						echo "moved window of name \"$name\" and pid \"$pid\"" >> ~/startOut
						# add 1 to the number of sorted windows
						let numSort+=1
						# Add to the list of windows that must be ignored
						sortedIds+=" $win"
						break
					fi
				fi
				let num+=1
			done
		fi
	done 
	sleep 1
	currentTime=$(date +%s)
	let timeSpent=$((currentTime-startTime))
done 

# Greet the user ;)
notify-send "Welcome back, fuckface"
# Focus on the right desktop
bspc desktop -f ^1
bspc desktop -f ^6
echo "Successfully ran start up script"
