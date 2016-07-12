if [[ $(pamixer --get-mute) == "false" ]]; then
	pamixer -m
elif [[ $(pamixer --get-mute) == "true" ]]; then
	pamixer -u
fi
