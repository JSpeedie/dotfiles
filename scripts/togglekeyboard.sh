builtinkeyid=$(xinput list | grep "AT Translated Set 2 keyboard" | grep -o "id=[0-9]\+" | grep -o "[0-9]\+")

# If the built in keyboard is floating (disabled)
if [[ $(xinput list | grep "AT Translated Set 2 keyboard.*float") ]]; then
	builtinmaster=$(xinput list | grep -o "slave\s\+keyboard.*[0-9]\+" | head -n 1 | grep -o "[0-9]\+")
	xinput reattach $builtinkeyid $builtinmaster
else
	xinput float $builtinkeyid
fi
