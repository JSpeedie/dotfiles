# If given a parameter
if [[ $1 != "" ]]; then
	# If the system has a built in keyboard
	if [[ $(xinput list | grep "AT Translated Set 2 keyboard") ]]; then
		# If the parameter is 1 (1 for "on"), then enable the keyboard
		if [[ "$1" == "1" ]]; then
			builtinkeyid=$(xinput list | grep "AT Translated Set 2 keyboard" | grep -o "id=[0-9]\+" | grep -o "[0-9]\+")
			builtinmaster=$(xinput list | grep -o "slave\s\+keyboard.*[0-9]\+" | head -n 1 | grep -o "[0-9]\+")
			xinput reattach $builtinkeyid $builtinmaster
		# If the parameter is 0 (0 for "off"), then disable the keyboard
		elif [[ "$1" == "0" ]]; then
				builtinkeyid=$(xinput list | grep "AT Translated Set 2 keyboard" | grep -o "id=[0-9]\+" | grep -o "[0-9]\+")
				xinput float $builtinkeyid
		fi
	fi
# If not given a parameter, simply toggle
else
	# If the system has a built in keyboard
	if [[ $(xinput list | grep "AT Translated Set 2 keyboard") ]]; then
		builtinkeyid=$(xinput list | grep "AT Translated Set 2 keyboard" | grep -o "id=[0-9]\+" | grep -o "[0-9]\+")
		# If the built in keyboard is floating (disabled)
		if [[ $(xinput list | grep "AT Translated Set 2 keyboard.*float") ]]; then
			builtinmaster=$(xinput list | grep -o "slave\s\+keyboard.*[0-9]\+" | head -n 1 | grep -o "[0-9]\+")
			xinput reattach $builtinkeyid $builtinmaster
		else
			xinput float $builtinkeyid
		fi
	else
		echo "incorrect usage"
	fi
fi
